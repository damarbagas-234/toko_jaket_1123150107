# Toko Jaket

Aplikasi e-commerce mobile berbasis Flutter untuk penjualan jaket secara online. Pengguna dapat menelusuri katalog produk, menambahkan item ke keranjang belanja, melakukan checkout, dan membayar menggunakan metode pembayaran E Uang (deeplink) maupun transfer bank. Aplikasi dilengkapi sistem autentikasi berbasis Firebase dan backend (Golang) REST API yang dikelola secara terpisah.

---

## Deskripsi Aplikasi

Toko Jaket adalah aplikasi belanja jaket yang dibangun untuk memenuhi kebutuhan transaksi jual beli secara digital. Fitur utama yang tersedia:

- Autentikasi pengguna dengan email/password melalui Firebase Authentication
- Verifikasi email sebelum mengakses dashboard
- Katalog produk dengan informasi lengkap (nama, harga, stok)
- Keranjang belanja dengan manajemen kuantitas item
- Proses checkout dengan pilihan metode pembayaran
- Pembayaran via E Uang menggunakan deeplink ke aplikasi dompet
- Pembayaran via transfer bank dengan polling status otomatis
- Halaman konfirmasi setelah pembayaran berhasil

---

## Arsitektur Aplikasi

Proyek ini mengikuti pola arsitektur **Feature-First Clean Architecture** dengan pemisahan layer yang jelas pada setiap fitur.

```
lib/
├── core/
│   ├── constants/       # Konstanta global (base URL, endpoint, warna, string)
│   ├── guards/          # AuthGuard untuk proteksi route yang membutuhkan login
│   ├── routes/          # Definisi semua route aplikasi (AppRouter)
│   ├── services/        # Layanan global (HTTP client, secure storage, E Uang service)
│   ├── theme/           # Konfigurasi tema Material (warna, tipografi)
│   └── widgets/         # Widget umum yang digunakan lintas fitur
│
└── features/
    ├── auth/
    │   ├── data/        # Repository dan sumber data autentikasi
    │   ├── domain/      # Model dan kontrak domain auth
    │   └── presentation/
    │       ├── pages/   # LoginPage, RegisterPage, VerifyEmailPage
    │       └── providers/ # AuthProvider (ChangeNotifier)
    │
    ├── dashboard/
    │   ├── data/        # Repository produk
    │   ├── domain/      # Model produk
    │   └── presentation/
    │       ├── pages/   # DashboardPage (katalog produk)
    │       └── providers/ # ProductProvider
    │
    ├── cart/
    │   ├── data/        # Repository keranjang belanja
    │   ├── domain/      # Model cart item
    │   └── presentation/
    │       ├── pages/   # CartPage, CheckoutPage
    │       └── providers/ # CartProvider
    │
    └── order/
        ├── data/        # Repository pesanan
        ├── domain/      # Model order
        └── presentation/
            ├── pages/   # MyOrdersPage, PaymentPendingPage, OrderSuccessPage
            └── providers/ # OrderProvider
```

### Alur Data

```
UI (Page/Widget)
    |
    v
Provider (ChangeNotifier)
    |
    v
Repository (data layer)
    |
    v
REST API Backend  /  Firebase Auth
```

State management menggunakan **Provider** (`ChangeNotifier`). Navigasi dikelola oleh `AppRouter` dengan `AuthGuard` sebagai pelindung route yang membutuhkan sesi aktif. Penyimpanan token menggunakan `flutter_secure_storage`. Komunikasi HTTP dilakukan melalui `Dio` dengan interceptor untuk inject token dan handle refresh otomatis.

---

## Cara Menjalankan Proyek

### Prasyarat

- Flutter SDK versi 3.x ke atas
- Dart SDK `^3.9.2`
- Android Studio atau VS Code dengan ekstensi Flutter
- Perangkat Android atau emulator (API 21+)
- Backend REST API aktif dan dapat diakses dari perangkat

### Langkah Instalasi

1. Clone repositori

   ```bash
   git clone https://github.com/damarbagas-234/toko_jaket_1123150107
   cd toko_jaket_1123150107
   ```

2. Install dependensi

   ```bash
   flutter pub get
   ```

3. Sesuaikan base URL backend

   Buka `lib/core/constants/app_constants.dart` dan ubah nilai `baseUrl` sesuai alamat IP server yang aktif:

   ```dart
   static const String baseUrl = 'http://<ip-server>:8080/v1';
   ```

4. Pastikan file konfigurasi Firebase tersedia

   File `google-services.json` harus berada di `android/app/` dan `lib/firebase_options.dart` sudah dikonfigurasi sesuai project Firebase yang digunakan.

5. Jalankan aplikasi

   ```bash
   flutter run
   ```

   pastikan backend nya sudah jalana :
   <br>
   [be-toko-jaket (repo backend)](https://github.com/damarbagas-234/tugas_week_5_1123150107)
    ```bash
    go run main.go
    ```

---

## Daftar Dependensi Utama

| Paket | Versi | Kegunaan |
|---|---|---|
| `provider` | ^6.1.5+1 | State management dengan ChangeNotifier |
| `firebase_core` | ^4.6.0 | Inisialisasi Firebase |
| `firebase_auth` | ^6.3.0 | Autentikasi pengguna via Firebase |
| `google_sign_in` | ^6.2.1 | Login dengan akun Google |
| `dio` | ^5.9.2 | HTTP client dengan interceptor |
| `equatable` | ^2.0.8 | Perbandingan objek berdasarkan nilai |
| `email_validator` | ^3.0.0 | Validasi format email |
| `flutter_svg` | ^2.2.4 | Render aset gambar SVG |
| `url_launcher` | ^6.3.2 | Membuka URL / deeplink eksternal |
| `flutter_secure_storage` | ^10.0.0 | Penyimpanan token secara aman |
| `app_links` | ^6.3.2 | Menangani incoming deeplink (payment callback) |

---

## Screenshot Aplikasi



---

## Link Video Presentasi

Link Youtube  [Klik](https://youtu.be/690s7cxgKmI)
