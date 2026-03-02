#!/bin/bash

# =======================================================
# Slipstream Tunnel Auto Script
# GitHub: https://github.com/AmirHBuilds/slipstream-tunnel
# =======================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
INSTALL_DIR="/root/slipstream"
SERVICE_FILE="/etc/systemd/system/slipstream.service"
GITHUB_REPO="https://github.com/AmirHBuilds/slipstream-tunnel"
GITHUB_RAW="https://github.com/AmirHBuilds/slipstream-tunnel/raw/main"

# Files list
FILE_CLIENT="slipstream-client"
FILE_SERVER="slipstream-server"
FILE_DEB1="ca-certificates_20240203_all.deb"
FILE_DEB2="libssl3t64_3.0.13-0ubuntu3.6_amd64.deb"

mkdir -p "$INSTALL_DIR"

# Helper Functions
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_input() { echo -e "${YELLOW}[INPUT]${NC} $1"; }

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run as root"
        exit 1
    fi
}

install_dependencies() {
    print_info "Installing system dependencies..."
    apt-get update -y
    apt-get install -y openssl wget curl
    
    # Install the specific debs if present
    if [ -f "$INSTALL_DIR/$FILE_DEB1" ]; then
        print_info "Installing $FILE_DEB1..."
        dpkg -i "$INSTALL_DIR/$FILE_DEB1"
    fi
    if [ -f "$INSTALL_DIR/$FILE_DEB2" ]; then
        print_info "Installing $FILE_DEB2..."
        dpkg -i "$INSTALL_DIR/$FILE_DEB2" || apt-get install -f -y
    fi
}

get_files_iran() {
    print_input "How do you want to get the files?"
    echo "1) Download automatically from GitHub"
    echo "2) I have files locally on this server"
    read -p "Select option: " file_opt

    if [ "$file_opt" == "1" ]; then
        print_info "Downloading files from GitHub..."
        wget -O "$INSTALL_DIR/$FILE_CLIENT" "$GITHUB_RAW/$FILE_CLIENT"
        wget -O "$INSTALL_DIR/$FILE_DEB1" "$GITHUB_RAW/$FILE_DEB1"
        wget -O "$INSTALL_DIR/$FILE_DEB2" "$GITHUB_RAW/$FILE_DEB2"
    elif [ "$file_opt" == "2" ]; then
        print_input "Enter the full path to the directory containing files (e.g., /root/downloads):"
        read -p "Path: " local_path
        
        if [ -d "$local_path" ]; then
            cp "$local_path/$FILE_CLIENT" "$INSTALL_DIR/"
            cp "$local_path/$FILE_DEB1" "$INSTALL_DIR/"
            cp "$local_path/$FILE_DEB2" "$INSTALL_DIR/"
            print_success "Files copied."
        else
            print_error "Directory not found!"
            exit 1
        fi
    else
        print_error "Invalid option"
        exit 1
    fi

    chmod +x "$INSTALL_DIR/$FILE_CLIENT"
    install_dependencies
}

get_files_kharej() {
    print_info "Downloading Server files from GitHub..."
    wget -O "$INSTALL_DIR/$FILE_SERVER" "$GITHUB_RAW/$FILE_SERVER"
    wget -O "$INSTALL_DIR/$FILE_DEB1" "$GITHUB_RAW/$FILE_DEB1"
    wget -O "$INSTALL_DIR/$FILE_DEB2" "$GITHUB_RAW/$FILE_DEB2"
    
    chmod +x "$INSTALL_DIR/$FILE_SERVER"
    install_dependencies
}

generate_cert() {
    print_info "Generating Self-Signed Certificate..."
    cd "$INSTALL_DIR"
    openssl req -x509 -newkey rsa:2048 -nodes \
      -keyout key.pem -out cert.pem -days 365 \
      -subj "/CN=slipstream"
    
    if [ -f "cert.pem" ] && [ -f "key.pem" ]; then
        print_success "Certificates generated successfully."
    else
        print_error "Failed to generate certificates."
        exit 1
    fi
}

setup_iran() {
    print_info "Starting Iran Setup..."
    get_files_iran

    print_input "Enter Tunnel Domain (e.g., b.example.com):"
    read -p "Domain: " DOMAIN

    print_input "Enter Port to Forward (This is the port you connect to, e.g., 1087):"
    read -p "Port: " PORT

    print_input "Enter DNS Resolver (Default: 8.8.8.8):"
    read -p "DNS [8.8.8.8]: " DNS_IP
    DNS_IP=${DNS_IP:-8.8.8.8}
    
    # Create Service
    cat <<EOF > $SERVICE_FILE
[Unit]
Description=Slipstream DNS Tunnel Client (Iran)
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/$FILE_CLIENT \\
  --tcp-listen-port $PORT \\
  --resolver $DNS_IP:53 \\
  --domain $DOMAIN \\
  --debug-poll

Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

    print_success "Service file created."
    systemctl daemon-reload
    systemctl enable slipstream
    systemctl start slipstream
    print_success "Slipstream started on Port $PORT!"
}

setup_kharej() {
    print_info "Starting Kharej Setup..."
    get_files_kharej
    generate_cert

    print_input "Enter Tunnel Domain (The NS record domain, e.g., b.example.com):"
    read -p "Domain: " DOMAIN

    print_input "Enter Target Port (The port where your Proxy/VPN listens, e.g., 1087):"
    read -p "Target Port: " PORT

    # Create Service
    cat <<EOF > $SERVICE_FILE
[Unit]
Description=Slipstream DNS Tunnel Server (Kharej)
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/$FILE_SERVER \\
  --dns-listen-port 53 \\
  --target-address 127.0.0.1:$PORT \\
  --domain $DOMAIN \\
  --cert $INSTALL_DIR/cert.pem \\
  --key $INSTALL_DIR/key.pem

Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

    print_success "Service file created."
    systemctl stop systemd-resolved 2>/dev/null 
    systemctl disable systemd-resolved 2>/dev/null
    print_info "Disabled systemd-resolved to free port 53."

    systemctl daemon-reload
    systemctl enable slipstream
    systemctl start slipstream
    print_success "Slipstream Server started!"
}

menu_status() {
    systemctl status slipstream
}

menu_edit() {
    nano $SERVICE_FILE
    print_input "Do you want to restart the service to apply changes? (y/n)"
    read -p "Choice: " rst
    if [[ "$rst" == "y" ]]; then
        systemctl daemon-reload
        systemctl restart slipstream
        print_success "Restarted."
    fi
}

menu_uninstall() {
    print_input "Are you sure you want to uninstall? (y/n)"
    read -p "Choice: " un
    if [[ "$un" == "y" ]]; then
        systemctl stop slipstream
        systemctl disable slipstream
        rm $SERVICE_FILE
        rm -rf $INSTALL_DIR
        systemctl daemon-reload
        print_success "Uninstalled."
    fi
}

# Main Execution
check_root

while true; do
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${YELLOW}    Slipstream Tunnel Auto Manager       ${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo "1) Install - Iran Server"
    echo "2) Install - Kharej Server"
    echo "3) Check Status"
    echo "4) Edit Config"
    echo "5) Restart Service"
    echo "6) Uninstall"
    echo "0) Exit"
    echo -e "${BLUE}=========================================${NC}"
    read -p "Select option: " choice

    case $choice in
        1)
            setup_iran
            read -p "Press Enter to return to menu..."
            ;;
        2)
            setup_kharej
            read -p "Press Enter to return to menu..."
            ;;
        3)
            menu_status
            read -p "Press Enter to return to menu..."
            ;;
        4)
            menu_edit
            ;;
        5)
            systemctl restart slipstream
            print_success "Service restarted."
            sleep 2
            ;;
        6)
            menu_uninstall
            read -p "Press Enter to return to menu..."
            ;;
        0)
            exit 0
            ;;
        *)
            print_error "Invalid choice."
            sleep 1
            ;;
    esac
done
