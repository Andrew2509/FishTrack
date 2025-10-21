# Fish Track - Aplikasi Deteksi Kualitas Ikan Segar

Fish Track adalah aplikasi Flutter yang menggunakan teknologi AI untuk mendeteksi kualitas ikan segar dengan akurat dan cepat. Aplikasi ini dirancang dengan antarmuka yang futuristik dan fitur-fitur canggih untuk memberikan pengalaman pengguna yang optimal.

## 🚀 Fitur Utama

### 1. **Halaman Beranda Interaktif**

- Animasi latar belakang yang dinamis dengan efek air dan ikan berenang
- Tombol dengan efek hover dan animasi responsif
- Statistik pengguna yang ditampilkan secara real-time
- Transisi yang smooth dan menarik

### 2. **Sistem Poin dan Reward (Gamification)**

- Sistem poin untuk setiap deteksi yang berhasil
- Level system dengan threshold yang dapat dikustomisasi
- Badge dan lencana untuk pencapaian tertentu
- Progress bar yang menunjukkan kemajuan pengguna

### 3. **Mode Gelap dan Terang**

- Toggle mode gelap/terang yang mudah diakses
- Tema yang konsisten di seluruh aplikasi
- Pengaturan yang tersimpan secara otomatis

### 4. **Deteksi Ikan dengan Filter dan Efek**

- Kamera real-time untuk mengambil foto ikan
- Filter gambar untuk meningkatkan kualitas deteksi
- Pengaturan sensitivitas deteksi
- Hasil deteksi dengan analisis mendalam

### 5. **Riwayat Deteksi dan Statistik**

- Riwayat lengkap semua deteksi yang pernah dilakukan
- Statistik dengan chart dan grafik yang interaktif
- Filter berdasarkan kualitas ikan
- Export data untuk analisis lebih lanjut

### 6. **Profil Pengguna**

- Informasi profil dengan level dan poin
- Badge dan pencapaian yang telah diperoleh
- Statistik personal yang detail
- Progress tracking

### 7. **Notifikasi dan Pengaturan**

- Notifikasi push untuk update dan tips
- Pengaturan yang komprehensif
- Kustomisasi tema dan warna
- Reset data aplikasi

## 🛠️ Teknologi yang Digunakan

- **Flutter**: Framework utama untuk pengembangan aplikasi
- **Provider**: State management
- **Camera**: Akses kamera untuk mengambil foto
- **Image Picker**: Memilih gambar dari galeri
- **TFLite**: Machine learning untuk deteksi kualitas ikan
- **FL Chart**: Chart dan grafik untuk statistik
- **Lottie**: Animasi yang menarik
- **Shared Preferences**: Penyimpanan data lokal
- **SQLite**: Database lokal untuk riwayat

## 📱 Screenshot Aplikasi

### Halaman Beranda

- Animasi latar belakang yang dinamis
- Statistik pengguna yang real-time
- Tombol aksi cepat dengan animasi

### Halaman Deteksi

- Interface kamera yang intuitif
- Filter gambar yang canggih
- Hasil deteksi dengan analisis detail

### Halaman Profil

- Informasi pengguna yang lengkap
- Badge dan pencapaian
- Progress level yang menarik

## 🚀 Cara Menjalankan Aplikasi

1. **Clone Repository**

   ```bash
   git clone <repository-url>
   cd fish_track
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run Aplikasi**
   ```bash
   flutter run
   ```

## 📋 Persyaratan Sistem

- Flutter SDK 3.8.1 atau lebih baru
- Dart SDK 3.0.0 atau lebih baru
- Android SDK 21 atau lebih baru
- iOS 11.0 atau lebih baru

## 🎨 Desain dan UI/UX

### Tema Futuristik

- Gradien warna yang menarik
- Shadow dan elevation yang konsisten
- Border radius yang modern
- Typography yang jelas dan mudah dibaca

### Animasi

- Transisi yang smooth antar halaman
- Loading animation yang menarik
- Hover effects pada tombol
- Staggered animations untuk list items

### Responsive Design

- Layout yang adaptif untuk berbagai ukuran layar
- Grid system yang fleksibel
- Spacing yang konsisten

## 🔧 Konfigurasi

### Dependencies Utama

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  camera: ^0.11.2
  image_picker: ^1.1.2
  tflite_flutter: ^0.10.4
  fl_chart: ^0.68.0
  lottie: ^3.1.2
  animated_text_kit: ^4.2.2
  flutter_staggered_animations: ^1.1.1
```

### Assets

- `assets/images/`: Gambar dan icon
- `assets/animations/`: File Lottie animations
- `assets/models/`: Model AI untuk deteksi
- `assets/icons/`: Icon aplikasi

## 📊 Struktur Aplikasi

```
lib/
├── constants/          # Konstanta aplikasi
├── models/            # Model data
├── providers/         # State management
├── screens/           # Halaman aplikasi
├── widgets/           # Widget kustom
├── services/          # Layanan aplikasi
├── utils/             # Utility functions
└── main.dart          # Entry point
```

## 🎯 Fitur Mendatang

- [ ] Augmented Reality (AR) untuk deteksi real-time
- [ ] Integrasi dengan cloud storage
- [ ] Machine learning model yang lebih akurat
- [ ] Multi-language support
- [ ] Offline mode
- [ ] Social sharing features

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan buat issue atau pull request untuk:

- Bug fixes
- Feature requests
- Documentation improvements
- Code optimization

## 📄 Lisensi

Aplikasi ini dilisensikan di bawah MIT License. Lihat file `LICENSE` untuk detail lebih lanjut.

## 👥 Tim Pengembang

- **Lead Developer**: [Nama Developer]
- **UI/UX Designer**: [Nama Designer]
- **ML Engineer**: [Nama ML Engineer]

## 📞 Kontak

- Email: support@fishtrack.com
- Website: https://fishtrack.com
- GitHub: https://github.com/fishtrack

---

**Fish Track** - Deteksi Kualitas Ikan Segar dengan Teknologi AI Terdepan 🐟✨
