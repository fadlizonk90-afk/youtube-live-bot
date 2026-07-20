#!/bin/bash

# =========================================================
# YOUTUBE LIVE TELEGRAM BOT - ONE-COMMAND AUTO INSTALLER
# =========================================================

set -e

echo ""
echo "========================================================"
echo "🚀 YOUTUBE LIVE TELEGRAM BOT - AUTO INSTALLER"
echo "========================================================"
echo ""

# 1. Update & Install Dependencies (Node.js, PM2, FFmpeg)
echo "📦 [1/4] Memeriksa & Menginstall Dependencies System (Node.js, PM2, FFmpeg)..."
apt-get update -y > /dev/null 2>&1 || true
apt-get install -y curl git ffmpeg build-essential wget > /dev/null 2>&1 || true

if ! command -v node &> /dev/null; then
    echo "⚙️ Menginstall Node.js v20 LTS..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt-get install -y nodejs > /dev/null 2>&1
fi

if ! command -v pm2 &> /dev/null; then
    echo "⚙️ Menginstall PM2 Process Manager..."
    npm install -g pm2 > /dev/null 2>&1
fi

# 2. Siapkan Folder Kerja
echo "📁 [2/4] Menyiapkan Folder Kerja di /root/youtube-live-bot..."
mkdir -p /root/youtube-live-bot/media
cd /root/youtube-live-bot

# 3. Input Interaktif Lisensi User
echo ""
echo "========================================================"
echo "📝 KONFIGURASI LISENSI USER TELEGRAM"
echo "========================================================"

read -p "👤 Masukkan Telegram Owner ID Anda : " OWNER_ID
read -p "🤖 Masukkan Telegram Bot Token Anda: " BOT_TOKEN

if [ -z "$OWNER_ID" ] || [ -z "$BOT_TOKEN" ]; then
    echo "❌ Error: Telegram Owner ID dan Bot Token wajib diisi!"
    exit 1
fi

# 4. Buat config.json Otomatis
cat <<EOF > /root/youtube-live-bot/config.json
{
  "telegramToken": "$BOT_TOKEN",
  "ownerId": "$OWNER_ID",
  "allowedGroupId": "",
  "apiKey": "",
  "streams": {
    "1": {
      "streamKey": "",
      "videoFile": "live.mp4",
      "youtubeUrl": "",
      "isActive": false
    }
  }
}
EOF

# 5. Buat package.json Minimalis
cat <<EOF > /root/youtube-live-bot/package.json
{
  "name": "youtube-live-bot-client",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "telegraf": "^4.15.0"
  }
}
EOF

# Install node_modules lokal
npm install > /dev/null 2>&1 || true

# 6. Unduh File Aplikasi Terproteksi (app.js)
echo ""
echo "🔒 [3/4] Mengunduh Aplikasi Bot Terproteksi..."
curl -sSL https://raw.githubusercontent.com/fadlizonk90-afk/youtube-live-bot/main/app.js -o /root/youtube-live-bot/app.js

# 7. Jalankan Bot dengan PM2
echo ""
echo "🚀 [4/4] Menjalankan Bot di Latar Belakang (PM2)..."
pm2 delete youtube-live-bot > /dev/null 2>&1 || true
pm2 start app.js --name "youtube-live-bot"
pm2 save > /dev/null 2>&1 || true

echo ""
echo "========================================================"
echo "🎉 INSTALLASI YOUTUBE LIVE BOT BERHASIL!"
echo "========================================================"
echo "• Bot telah aktif & berjalan 24/7 di latar belakang."
echo "• Terkunci Khusus Telegram Owner ID: $OWNER_ID"
echo "• Buka Telegram Anda dan ketik /start atau /help untuk mulai!"
echo "========================================================"
echo ""
