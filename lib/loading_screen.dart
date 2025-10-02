import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'dart:async';

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
    // Timer(const Duration(seconds: 1), () {
    //   final Map<String, String> mapData = {
    //     "Persentase Penduduk Miskin":
    //         "/data-umum/pekerjaan/persentase-penduduk-miskin/",
    //     "Indeks Pembangunan Manusia (UHH-LF 2020)":
    //         "/data-umum/pekerjaan/ipm-uhhlf2020/",
    //   };
    //   print(mapData);
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => HomePage(mapData: mapData),
    //     ), // Ganti HomePage() dengan halaman utama Anda
    //   );
    // });
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('/data-umum/title/list_title/')
          .get();

      final QuerySnapshot igsnapshot = await FirebaseFirestore.instance
          .collection('infografis')
          .orderBy('time_upload', descending: true)
          .limit(4)
          .get();

      final QuerySnapshot pubsnapshot = await FirebaseFirestore.instance
          .collection('publikasi')
          .orderBy('release_time', descending: true)
          .limit(10)
          .get();

      final QuerySnapshot homeSnapshot = await FirebaseFirestore.instance
          .collection('home-display')
          .get();

      final List<String> listImage = igsnapshot.docs.map((doc) {
        return doc['image']?.toString() ?? '';
      }).toList();

      final fetchedMap = {
        for (var doc in snapshot.docs)
          (doc['judul'] as String): (doc['link'] as String),
      };

      final List<Map<String, String>> publications = pubsnapshot.docs.map((
        doc,
      ) {
        final data = doc.data() as Map<String, dynamic>;

        // 2. Ambil dan format timestamp
        String formattedDate = 'Tanggal tidak tersedia';
        if (data['release_time'] != null && data['release_time'] is Timestamp) {
          // Ubah Timestamp menjadi objek DateTime
          DateTime date = (data['release_time'] as Timestamp).toDate();
          formattedDate = DateFormat('d MMMM yyyy').format(date);
        }

        return {
          'image': data['cover']?.toString() ?? '',
          'date': formattedDate,
          'title': data['title']?.toString() ?? 'Tanpa Judul',
          'description':
              data['abstraction']?.toString() ?? 'Tidak ada deskripsi.',
          'NoKatal': data['katalog_num']?.toString() ?? '-',
          'NoPub': data['publication_num']?.toString() ?? '-',
          'ISSN/ISBN': data['issn']?.toString() ?? '-',
          'terbit': data['freq']?.toString() ?? '-',
          'link': data['pub_link']?.toString() ?? '-',
        };
      }).toList();
      print(publications);
      final List<Map<String, String>> statsData = homeSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'value': data['value']?.toString() ?? '',
          'label': data['label']?.toString() ?? 'Tidak ada Data',
        };
      }).toList();

      if (mounted) {
        // 2. Kirim data ke HomePage melalui constructor
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              mapData: fetchedMap,
              imgInfografis: listImage,
              pubSample: publications,
              statsData: statsData,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
      // Pastikan widget masih ada di tree sebelum menampilkan dialog
      if (!mounted) return;

      // Tampilkan dialog error
      showDialog(
        context: context,
        // Pengguna tidak bisa menutup dialog dengan menekan area luar
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Terjadi masalah pada Database."),
                  Text("Silakan coba lagi nanti."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // Tutup dialog saat tombol OK ditekan
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
