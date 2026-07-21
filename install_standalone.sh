#!/bin/bash

# =========================================================
# YOUTUBE LIVE STREAMING (STANDALONE WITH LICENSE) - AUTO INSTALLER
# =========================================================

set -e

echo ""
echo "========================================================"
echo "🚀 YOUTUBE LIVE STREAMING (STANDALONE) - AUTO INSTALLER"
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

# 3. Input Interaktif Lisensi, Stream Key & File Video
echo ""
echo "========================================================"
echo "📝 KONFIGURASI AKTIVASI LISENSI & SIARAN YOUTUBE"
echo "========================================================"

read -p "🔑 Masukkan Kode Lisensi Anda  : " LICENSE_KEY
read -p "🔑 Masukkan Stream Key YouTube Anda: " STREAM_KEY
read -p "📹 Masukkan Nama File Video (default: live.mp4): " VIDEO_FILE

if [ -z "$LICENSE_KEY" ]; then
    echo "❌ Error: Kode Lisensi wajib diisi!"
    exit 1
fi

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
  "licenseKey": "$LICENSE_KEY",
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
  },
  "dependencies": {
    "axios": "^1.6.0"
  }
}
EOF

# Install dependencies lokal
npm install > /dev/null 2>&1 || true

# 6. Unduh File Aplikasi Terproteksi (standalone_app.js)
echo ""
echo "🔒 [3/4] Mengunduh Aplikasi Streaming Terproteksi..."
curl -sSL https://raw.githubusercontent.com/fadlizonk90-afk/youtube-live-bot/main/standalone_app.js -o /root/youtube-live-standalone/standalone_app.js

# 7. Jalankan dengan PM2
echo ""
echo "🚀 [4/4] Menjalankan Auto-Streaming 24/7 di Latar Belakang (PM2)..."
pm2 delete youtube-live-standalone > /dev/null 2>&1 || true
pm2 start standalone_app.js --name "youtube-live-standalone"
pm2 save > /dev/null 2>&1 || true

echo ""
echo "========================================================"
echo "🎉 INSTALLASI YOUTUBE LIVE STREAMING BERHASIL!"
echo "========================================================"
echo "• Mode       : Standalone Auto-Loop 24/7"
echo "• Lisensi    : $LICENSE_KEY (Aktif Terproteksi)"
echo "• Status     : Active running under PM2"
echo "• Stream Key : $STREAM_KEY"
echo "• File Video : /root/youtube-live-standalone/media/$VIDEO_FILE"
echo ""
echo "💡 Catatan: Harap pastikan file video '$VIDEO_FILE' sudah ada di folder /root/youtube-live-standalone/media/"
echo "========================================================"
echo ""
