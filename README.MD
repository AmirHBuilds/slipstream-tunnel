
# Slipstream Tunnel Auto Script 🚀

An automated Bash script to easily set up, manage, and monitor the **Slipstream DNS Tunnel** on both Client (Iran) and Server (Kharej) sides. This script handles dependencies, file fetching, certificate generation, and systemd service creation automatically.

**GitHub Repository:** [AmirHBuilds/slipstream-tunnel](https://github.com/AmirHBuilds/slipstream-tunnel)

---

## 🇬🇧 English Documentation

### Features
- **Menu-based Interface:** Easy-to-use menu for installation, status checks, editing configs, and uninstallation.
- **Auto Dependency Handling:** Automatically installs `openssl`, `wget`, and required `.deb` libraries (`libssl`, `ca-certificates`).
- **Flexible File Sourcing:** 
  - On **Iran** servers: Choose between downloading from GitHub or using local files (useful if GitHub is restricted).
  - On **Kharej** servers: Files are fetched automatically.
- **Certificate Generation:** Automatically generates self-signed certificates (`cert.pem`, `key.pem`) on the server.
- **Service Management:** Creates permanent `systemd` services that auto-restart on failure.

### 📥 Installation Methods

#### Method 1: Quick Install (Recommended)
Run this single command on your server to download and start the script immediately:

```bash
sudo bash <(curl -Ls https://raw.githubusercontent.com/AmirHBuilds/slipstream-tunnel/refs/heads/main/install.sh)
```

#### Method 2: Manual / Local Install
If you already have `install.sh` on your server or prefer to download it manually:

1. Download or upload `install.sh` to your server.
2. Make it executable:
   ```bash
   chmod +x install.sh
   ```
3. Run the script:
   ```bash
   ./install.sh
   ```

---

### Usage Guide

#### 1. Kharej (Foreign) Server Setup
Select **Option 2** in the menu.
- **Prerequisite:** Port `53` (UDP/TCP) must be free. The script will attempt to stop `systemd-resolved`.
- **Domain:** Enter your tunnel domain (e.g., `ns.example.com`).
- **Target Port:** Enter the local port where your Proxy/VPN (X-UI, V2Ray, etc.) is listening (e.g., `1087`).
- **Result:** The script generates certificates and starts the server listening on Port 53.

#### 2. Iran (Domestic) Server Setup
Select **Option 1** in the menu.
- **File Source:** 
  - Select `1` to download files from GitHub automatically.
  - Select `2` if you have the files locally (useful for restricted networks). You will be asked for the folder path.
- **Domain:** Enter the **same domain** used on the Kharej server.
- **Port:** Enter the port you want to listen on (e.g., `1087`).
- **DNS:** Enter a DNS resolver (default: `8.8.8.8`).

#### 3. Management
Run the script again (`./install.sh` or the curl command) to access the menu:
- **Check Status:** View logs and running status.
- **Edit Config:** Modify parameters without reinstalling.
- **Restart Service:** Quickly restart the tunnel.
- **Uninstall:** Remove the service and files completely.

---

## 🇮🇷 راهنمای فارسی

### امکانات
- **منوی مدیریت:** رابط کاربری ساده برای نصب، بررسی وضعیت، ویرایش و حذف.
- **نصب خودکار پیش‌نیازها:** نصب اتوماتیک پکیج‌های `.deb` مورد نیاز و کتابخانه‌ها.
- **انتخاب منبع فایل‌ها:**
  - در **سرور ایران**: می‌توانید انتخاب کنید فایل‌ها از گیت‌هاب دانلود شوند یا از فایل‌های موجود در پوشه سرور استفاده شود (مناسب برای زمان‌هایی که گیت‌هاب فیلتر است).
  - در **سرور خارج**: فایل‌ها به صورت خودکار دانلود می‌شوند.
- **ساخت سرتیفیکیت:** ساخت خودکار فایل‌های `cert.pem` و `key.pem`.
- **سرویس پایدار:** ایجاد سرویس `systemd` که در صورت ریستارت سرور یا کرش کردن، تانل را مجدد اجرا می‌کند.

### 📥 روش‌های نصب

#### روش ۱: نصب سریع (پیشنهادی)
کد زیر را کپی کرده و در ترمینال سرور خود اجرا کنید:

```bash
sudo bash <(curl -Ls https://raw.githubusercontent.com/AmirHBuilds/slipstream-tunnel/refs/heads/main/install.sh)
```

#### روش ۲: نصب دستی / لوکال
اگر فایل `install.sh` را روی سرور دارید یا می‌خواهید دستی آپلود کنید:

۱. فایل `install.sh` را در سرور قرار دهید.
۲. دسترسی اجرا به آن بدهید:
   ```bash
   chmod +x install.sh
   ```
۳. اسکریپت را اجرا کنید:
   ```bash
   ./install.sh
   ```

---

### راهنمای استفاده

#### ۱. تنظیمات سرور خارج (Kharej)
گزینه **2** را انتخاب کنید.
- **پورت ۵۳:** این پورت باید آزاد باشد (اسکریپت سعی می‌کند سرویس‌های مزاحم را غیرفعال کند).
- **Domain:** دامنه تانل را وارد کنید (دامنه‌ای که رکورد NS دارد).
- **Target Port:** پورتی که پنل یا پروکسی شما (مثل X-UI) روی آن در حال اجراست را وارد کنید (مثلاً `1087`).
- **نتیجه:** اسکریپت سرتیفیکیت می‌سازد و روی پورت ۵۳ آماده دریافت ترافیک می‌شود.

#### ۲. تنظیمات سرور ایران (Iran)
گزینه **1** را انتخاب کنید.
- **File Source:**
  - عدد `1` را بزنید تا فایل‌ها از اینترنت دانلود شوند.
  - عدد `2` را بزنید اگر فایل‌ها را دستی روی سرور ریخته‌اید (باید آدرس پوشه فایل‌ها را وارد کنید).
- **Domain:** همان دامنه‌ای که در سرور خارج تنظیم کردید را وارد کنید.
- **Port:** پورتی که می‌خواهید در ایران باز شود (مثلاً `1087`).
- **DNS:** آدرس DNS را وارد کنید (پیش‌فرض `8.8.8.8` مناسب است).

#### ۳. مدیریت
با اجرای مجدد اسکریپت به منو دسترسی خواهید داشت:
- **Check Status:** بررسی وضعیت اتصال و لاگ‌ها.
- **Edit Config:** ویرایش فایل کانفیگ سرویس.
- **Uninstall:** حذف کامل سرویس و فایل‌ها.

---

### Required Files (For Local Install) | فایل‌های مورد نیاز
If you choose **Option 2** (Local Files) in Iran setup, ensure these files exist in your folder:
اگر گزینه لوکال را انتخاب می‌کنید، این فایل‌ها باید در پوشه باشند:

- `slipstream-server`
- `slipstream-client`
- `ca-certificates_20240203_all.deb`
- `libssl3t64_3.0.13-0ubuntu3.6_amd64.deb`

---
**Credits:** Based on Amo Mamad's tutorial.
**Donate (Tron):** `TJ2FvNqyqxkwhs9W1dLT74ggN3LNTESXuf`
```
