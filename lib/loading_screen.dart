import 'dart:async'; // Diperlukan untuk Timer
import 'package:flutter/material.dart';
import 'home_page.dart'; // Ganti dengan halaman utama aplikasi Anda nanti

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Atur timer untuk pindah ke halaman utama setelah 3 detik
    Timer(const Duration(seconds: 5), () {
      // Navigator.pushReplacement digunakan agar pengguna tidak bisa kembali ke Loading screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // Ganti HomePage() dengan halaman utama Anda
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Atur warna latar belakang sesuai gambar Anda
      backgroundColor: const Color(0xFF0D254C), // Contoh warna biru tua
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilkan logo dari folder assets
            Image.asset(
              'lib/assets/logo bps.png', // Pastikan nama file sesuai
              width: 150, // Sesuaikan ukuran logo
            ),
            const SizedBox(height: 14), // Beri jarak antara logo dan teks
            const Text(
              "LAPIS SATU",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Layanan Pengaduan dan Diseminasi\nStatistik Satu Pintu",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}