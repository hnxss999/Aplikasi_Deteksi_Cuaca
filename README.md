# ✨ Aplikasi Deteksi Cuaca

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white&style=for-the-badge)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white&style=for-the-badge)](https://dart.dev/)
[![Linter](https://img.shields.io/badge/Linter-Dart%20Analyzer-blueviolet?style=for-the-badge)](https://dart.dev/guides/language/effective-dart/style)
[![Tests](https://img.shields.io/badge/Tests-Included-brightgreen?style=for-the-badge)](#✨-fitur-utama)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

> Aplikasi Deteksi Cuaca adalah aplikasi multi-platform modern yang dikembangkan dengan Flutter, dirancang untuk menyediakan informasi cuaca secara real-time dan intuitif kepada pengguna di berbagai perangkat.

---

## ✨ Fitur Utama

Proyek ini, dibangun di atas kerangka kerja Flutter, menghadirkan fondasi yang kuat untuk aplikasi deteksi cuaca yang kaya fitur, dengan fokus pada pengalaman pengguna lintas platform dan kualitas kode.

*   **Pengembangan Multi-platform:** Dengan satu basis kode Dart dan Flutter, aplikasi ini mendukung kompilasi dan penyebaran ke berbagai platform, termasuk Android, iOS, Web, Linux, macOS, dan Windows, memastikan jangkauan yang luas.
*   **Antarmuka Pengguna Reaktif (Reactive UI):** Memanfaatkan arsitektur widget deklaratif Flutter untuk membangun antarmuka pengguna yang responsif, visual yang menarik, dan berkinerja tinggi, yang beradaptasi dengan mulus di berbagai ukuran layar dan orientasi.
*   **Manajemen Dependensi Efisien:** Mengelola pustaka dan paket eksternal secara efisien menggunakan `pubspec.yaml`, memastikan dependensi yang terorganisir dan dapat dikelola untuk pengembangan yang lancar.
*   **Kualitas Kode dan Standar:** Menegakkan standar pengkodean yang tinggi dan mendeteksi potensi masalah lebih awal dalam siklus pengembangan melalui konfigurasi Dart Analyzer yang komprehensif (`analysis_options.yaml`).
*   **Pengujian Widget Terintegrasi:** Memastikan keandalan dan fungsionalitas komponen UI yang tepat dengan kerangka kerja pengujian widget terintegrasi Flutter, memfasilitasi pengembangan yang kuat.
*   **Struktur Proyek yang Skalabel:** Mengikuti struktur proyek Flutter standar, membuat aplikasi mudah dipahami, dipelihara, dan diskalakan untuk fitur dan fungsionalitas di masa mendatang.

## 🛠️ Tumpukan Teknologi

| Kategori            | Teknologi             | Catatan                                                                                                                                                                                                                                                                                                                       |
| :------------------ | :-------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Kerangka Kerja UI** | Flutter               | Kerangka kerja UI multi-platform dari Google untuk membangun aplikasi secara native untuk seluler, web, dan desktop dari satu basis kode.                                                                                                                                                                                      |
| **Bahasa Pemrograman**| Dart                  | Bahasa pemrograman yang dioptimalkan klien yang dikembangkan oleh Google, digunakan untuk membangun aplikasi di web, seluler, dan desktop.                                                                                                                                                                                    |
| **Manajemen Paket** | `pub` (Dart)          | Manajer paket resmi untuk ekosistem Dart/Flutter, digunakan untuk mendeklarasikan dan mengelola dependensi proyek yang tercantum dalam `pubspec.yaml`.                                                                                                                                                                    |
| **Kualitas Kode**   | Dart Analyzer/Linting | Alat analisis statis terintegrasi yang digunakan untuk menegakkan praktik terbaik pengkodean, mendeteksi kesalahan potensial, dan memastikan konsistensi kode melalui aturan yang ditentukan dalam `analysis_options.yaml`.                                                                                                    |
| **Lingkungan Target**| Android, iOS, Web,    | Aplikasi ini dikonfigurasi untuk membangun dan menyebarkan ke berbagai platform ini, memanfaatkan kekuatan Flutter untuk pengalaman pengguna yang konsisten di seluruh ekosistem.                                                                                                                                                |
|                     | Linux, macOS, Windows |                                                                                                                                                                                                                                                                                                                           |

## 🏛️ Tinjauan Arsitektur

Aplikasi ini dibangun menggunakan kerangka kerja Flutter, yang memungkinkan pengembangan UI yang reaktif dan deklaratif dari satu basis kode untuk beberapa platform. Ini mengikuti arsitektur aplikasi klien-sisi standar Flutter, dengan `lib/main.dart` sebagai titik masuk utama dan memanfaatkan hierarki widget untuk membangun antarmuka pengguna.

Struktur proyek mencerminkan kemampuan multi-platform Flutter, dengan direktori tingkat atas untuk setiap target platform (`android`, `ios`, `linux`, `macos`, `web`, `windows`). Direktori ini berisi konfigurasi proyek native yang diperlukan untuk mengkompilasi dan menjalankan aplikasi Flutter di lingkungan masing-masing, sementara logika aplikasi inti dan UI ditentukan dalam file Dart di direktori `lib/`. Pendekatan ini memastikan pengalaman pengguna yang konsisten dan kinerja yang optimal di seluruh perangkat.

## 🚀 Memulai

Untuk menyiapkan dan menjalankan proyek ini di lingkungan pengembangan lokal Anda, ikuti langkah-langkah di bawah ini.

### Prasyarat

Pastikan Anda telah menginstal yang berikut ini:

*   **Flutter SDK**: Ikuti petunjuk instalasi di [Situs Web Resmi Flutter](https://flutter.dev/docs/get-started/install).
*   **Dart SDK**: Biasanya disertakan dengan instalasi Flutter SDK.

### Instalasi

1.  **Kloning repositori:**

    ```bash
    git clone https://github.com/hnxss999/Aplikasi_Deteksi_Cuaca.git
    cd Aplikasi_Deteksi_Cuaca
    ```

2.  **Instal dependensi Flutter:**

    ```bash
    flutter pub get
    ```

3.  **Jalankan aplikasi:**
    Pilih perangkat target Anda (misalnya, emulator Android, simulator iOS, browser Chrome, atau desktop) dan jalankan aplikasi.

    ```bash
    flutter run
    ```
    Atau untuk menjalankan di perangkat tertentu:
    ```bash
    flutter run -d <nama_perangkat_atau_id>
    ```

## 📂 Struktur File

```
/
├── .gitignore
├── .metadata
├── README.md
├── analysis_options.yaml
├── android
│   ├── app
│   └── ...
├── ios
│   ├── Runner.xcodeproj
│   ├── Runner.xcworkspace
│   ├── Runner
│   └── ...
├── lib
│   └── main.dart
├── linux
│   ├── flutter
│   └── runner
├── macos
│   ├── Flutter
│   ├── Runner.xcodeproj
│   ├── Runner.xcworkspace
│   ├── Runner
│   └── ...
├── pubspec.lock
├── pubspec.yaml
├── test
│   └── widget_test.dart
├── web
│   ├── icons
│   └── index.html
└── windows
    ├── flutter
    └── runner
```

*   **`lib/`**: Direktori utama untuk kode sumber aplikasi Flutter. Semua logika dan UI aplikasi yang ditulis dalam Dart berada di sini, dengan `main.dart` sebagai titik masuk.
*   **`android/`**: Berisi proyek Android native yang digunakan untuk membangun aplikasi Flutter untuk platform Android.
*   **`ios/`**: Berisi proyek iOS native (Xcode) yang digunakan untuk membangun aplikasi Flutter untuk platform iOS.
*   **`web/`**: Berisi file-file yang diperlukan untuk menjalankan aplikasi Flutter sebagai aplikasi web (misalnya, `index.html`, `manifest.json`, ikon).
*   **`linux/`**, **`macos/`**, **`windows/`**: Berisi proyek native dan konfigurasi yang diperlukan untuk membangun dan menjalankan aplikasi Flutter di masing-masing platform desktop.
*   **`pubspec.yaml`**: File konfigurasi proyek Dart/Flutter, yang mendefinisikan metadata proyek, dependensi, aset, dan versi.
*   **`analysis_options.yaml`**: File konfigurasi untuk Dart Analyzer, menentukan aturan linting dan standar kualitas kode.
*   **`test/`**: Berisi file pengujian untuk aplikasi (misalnya, pengujian unit, pengujian widget).