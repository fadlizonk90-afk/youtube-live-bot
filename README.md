# YouTube Live Streaming Distribution (Auto Installer)

Repository distribusi otomatis untuk YouTube Live Streaming.

---

## 📌 OPSI 1: Dengan Bot Telegram & Sistem Lisensi

Digunakan untuk pembeli yang ingin mengontrol siaran live dari Telegram:

```bash
wget -qO- https://raw.githubusercontent.com/fadlizonk90-afk/youtube-live-bot/main/install.sh | bash
```

---

## 📌 OPSI 2: Standalone Live Streaming 24/7 (TANPA BOT & TANPA AKTIVASI)

Digunakan untuk siaran live otomatis 24/7 langsung di VPS tanpa Telegram bot & tanpa kode aktivasi lisensi:

```bash
wget -qO- https://raw.githubusercontent.com/fadlizonk90-afk/youtube-live-bot/main/install_standalone.sh | bash
```

### 💡 Keunggulan Opsi 2 (Tanpa Bot):
- **100% Otomatis**: Cukup masukkan Stream Key YouTube di terminal VPS.
- **Tanpa Aktivasi**: Langsung jalan tanpa perlu lisensi atau Telegram Bot.
- **Kode Terenkripsi**: Program `standalone_app.js` terlindungi (0% kebocoran source code).
- **Auto-Loop 24/7**: Berjalan di latar belakang under PM2 dengan fitur auto-reconnect jika koneksi terputus.
