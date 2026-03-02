# Slipstream Tunnel Auto Script 🚀

An automated Bash script to easily set up and manage the **Slipstream DNS Tunnel** on both Client (Iran) and Server (Kharej) sides. This script handles dependencies, file fetching, certificate generation, and systemd service creation automatically.

**GitHub Repository:** [AmirHBuilds/slipstream-tunnel](https://github.com/AmirHBuilds/slipstream-tunnel)

---

## 🇬🇧 English Documentation

### Features
- **Menu-based Interface:** Easy to use menu for installation, status checks, and configuration.
- **Auto Dependency Installation:** Automatically installs `openssl`, `wget`, and required `.deb` libraries (`libssl`, `ca-certificates`).
- **Flexible File Sourcing:** 
  - On **Iran** servers, choose between downloading from GitHub or using local files present on the server.
  - On **Kharej** servers, files are fetched automatically.
- **Certificate Generation:** Automatically generates self-signed certificates (`cert.pem`, `key.pem`) on the server.
- **Service Management:** Creates permanent `systemd` services that auto-restart on failure.

### Prerequisites
- Root access to the server.
- **Kharej Server:** Port `53` (UDP/TCP) must be free. The script will attempt to stop `systemd-resolved` to free this port.
- **Domain Setup:** You need a domain with an `NS` record pointing to your Kharej server IP (e.g., `A.domain.com` -> IP, `B.domain.com` -> NS -> `A.domain.com`).

### Installation
Since the `install.sh` script is already on your server, simply give it execution permissions and run it:

```bash
chmod +x install.sh
./install.sh
```

### Usage Guide

#### 1. Kharej (Foreign) Server Setup
Select **Option 2** in the menu.
- **Domain:** Enter your tunnel domain (the one with the NS record).
- **Target Port:** Enter the port where your proxy (X-UI, V2Ray, etc.) is listening locally (e.g., `1087`).
- The script will generate certificates and start listening on Port 53.

#### 2. Iran (Domestic) Server Setup
Select **Option 1** in the menu.
- **File Source:** 
  - Select `1` to download files from GitHub.
  - Select `2` if you have uploaded the required files manually. You will be asked for the folder path.
- **Domain:** Enter the same domain used on the Kharej server.
- **Port:** Enter the port you want to listen on (e.g., `1087`).
- **DNS:** Enter a DNS resolver (default: `8.8.8.8`).

#### 3. Management
Run `./install.sh` again to access the menu:
- **Check Status:** See if the tunnel is running.
- **Edit Config:** Modify the service file easily.
- **Uninstall:** Remove the service and files.

---

## 🇮🇷 راهنمای فارسی

### امکانات
- **منوی مدیریت:** رابط کاربری ساده برای نصب، بررسی وضعیت و ویرایش.
- **نصب خودکار پیش‌نیازها:** نصب اتوماتیک پکیج‌های `.deb` مورد نیاز و کتابخانه‌ها.
- **انتخاب منبع فایل‌ها:**
  - در **سرور ایران**، می‌توانید انتخاب کنید فایل‌ها از گیت‌هاب دانلود شوند یا از فایل‌های موجود در سرور استفاده شود.
  - در **سرور خارج**، فایل‌ها به صورت خودکار دانلود می‌شوند.
- **ساخت سرتیفیکیت:** ساخت خودکار فایل‌های `cert.pem` و `key.pem`.
- **سرویس پایدار:** ایجاد سرویس `systemd` که در صورت ریستارت سرور یا کرش کردن، تانل را مجدد اجرا می‌کند.

### پیش‌نیازها
- دسترسی روت (Root) به سرور.
- **سرور خارج:** پورت `53` باید آزاد باشد (اسکریپت تلاش می‌کند سرویس‌های مزاحم را غیرفعال کند).
- **دامنه:** نیاز به یک ساب‌دامنه با رکورد `NS` دارید.

### نصب و اجرا
از آنجایی که فایل `install.sh` روی سرور شما موجود است، کافیست دستورات زیر را وارد کنید:

```bash
chmod +x install.sh
./install.sh
```

### راهنمای استفاده

#### ۱. تنظیمات سرور خارج (Kharej)
گزینه **2** را انتخاب کنید.
- **Domain:** دامنه تانل را وارد کنید (دامنه‌ای که رکورد NS دارد).
- **Target Port:** پورتی که پنل یا پروکسی شما (مثل X-UI) روی آن در حال اجراست را وارد کنید (مثلاً `1087`).
- اسکریپت به صورت خودکار سرتیفیکیت می‌سازد و روی پورت 53 گوش می‌دهد.

#### ۲. تنظیمات سرور ایران (Iran)
گزینه **1** را انتخاب کنید.
- **File Source:**
  - عدد `1` را بزنید تا فایل‌ها از اینترنت دانلود شوند.
  - عدد `2` را بزنید اگر فایل‌ها را دستی روی سرور ریخته‌اید (باید آدرس پوشه فایل‌ها را وارد کنید).
- **Domain:** همان دامنه‌ای که در خارج تنظیم کردید را وارد کنید.
- **Port:** پورتی که می‌خواهید در ایران باز شود (مثلاً `1087`).
- **DNS:** آدرس DNS را وارد کنید (پیش‌فرض `8.8.8.8` مناسب است).

#### ۳. مدیریت
با اجرای مجدد `./install.sh` به منو دسترسی خواهید داشت:
- **Check Status:** بررسی وضعیت اتصال.
- **Edit Config:** ویرایش سریع فایل کانفیگ.
- **Uninstall:** حذف کامل تانل و فایل‌ها.

### لیست فایل‌های مورد نیاز (برای حالت آفلاین)
Required files structure if using local files:
- `slipstream-server`
- `slipstream-client`
- `ca-certificates_20240203_all.deb`
- `libssl3t64_3.0.13-0ubuntu3.6_amd64.deb`

---
Developed by **AmirHBuilds** & **Amo Mamad** Community.
---
