#!/bin/bash

# =========================================================
# YOUTUBE LIVE STREAMING (TANPA BOT TELEGRAM) - AUTO INSTALLER
# =========================================================

set -e

echo ""
echo "========================================================"
echo "🚀 YOUTUBE LIVE STREAMING (TANPA BOT) - AUTO INSTALLER"
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
echo "📁 [2/4] Menyiapkan Folder Kerja di /root/youtube-live-standalone..."
mkdir -p /root/youtube-live-standalone/media
cd /root/youtube-live-standalone

# 3. Input Interaktif Stream Key & File Video
echo ""
echo "========================================================"
echo "📝 KONFIGURASI SIARAN YOUTUBE (TANPA BOT)"
echo "========================================================"

read -p "🔑 Masukkan Stream Key YouTube Anda: " STREAM_KEY
read -p "📹 Masukkan Nama File Video (default: live.mp4): " VIDEO_FILE

if [ -z "$STREAM_KEY" ]; then
    echo "❌ Error: Stream Key YouTube wajib diisi!"
    exit 1
fi

if [ -z "$VIDEO_FILE" ]; then
    VIDEO_FILE="live.mp4"
fi

# 4. Buat stream_config.json Otomatis
cat <<EOF > /root/youtube-live-standalone/stream_config.json
{
  "streamKey": "$STREAM_KEY",
  "videoFile": "$VIDEO_FILE",
  "rtmpUrl": "rtmp://a.rtmp.youtube.com/live2",
  "fps": 30,
  "bitrate": "4000k"
}
EOF

# 5. Buat package.json Minimalis
cat <<EOF > /root/youtube-live-standalone/package.json
{
  "name": "youtube-live-standalone",
  "version": "1.0.0",
  "main": "standalone_app.js",
  "scripts": {
    "start": "node standalone_app.js"
  }
}
EOF

# 6. Unduh File Aplikasi Terproteksi (standalone_app.js)
echo ""
echo "🔒 [3/4] Mengunduh Aplikasi Streaming Terproteksi (Tanpa Bot)..."
curl -sSL https://raw.githubusercontent.com/fadlizonk90-afk/youtube-live-bot/main/standalone_app.js -o /root/youtube-live-standalone/standalone_app.js

# 7. Jalankan dengan PM2
echo ""
echo "🚀 [4/4] Menjalankan Auto-Streaming 24/7 di Latar Belakang (PM2)..."
pm2 delete youtube-live-standalone > /dev/null 2>&1 || true
pm2 start standalone_app.js --name "youtube-live-standalone"
pm2 save > /dev/null 2>&1 || true

echo ""
echo "========================================================"
echo "🎉 INSTALLASI YOUTUBE LIVE STREAMING (TANPA BOT) BERHASIL!"
echo "========================================================"
echo "• Mode       : Standalone Auto-Loop 24/7 (Tanpa Bot Telegram)"
echo "• Status     : Active running under PM2"
echo "• Stream Key : $STREAM_KEY"
echo "• File Video : /root/youtube-live-standalone/media/$VIDEO_FILE"
echo ""
echo "💡 Catatan: Harap pastikan file video '$VIDEO_FILE' sudah ada di folder /root/youtube-live-standalone/media/"
echo "========================================================"
echo ""
