import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';

import 'dart:async';

import 'home_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
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
          .get();

      final QuerySnapshot homeSnapshot = await FirebaseFirestore.instance
          .collection('home-display')
          .get();

      final List<String> listImage = igsnapshot.docs.map((doc) {
        return doc['image']?.toString() ?? '';
      }).toList();
      final fetchedMap = {
        for (var doc in snapshot.docs)
          (doc.data()['judul'] as String): {
            'id': doc.id,
            'link': doc.data()['link'] as String,
            'category': doc.data()['category'] as int,
            'subcategory': doc.data()['subcategory'] ?? 0,
            // 'root': (doc.data()['root'] ?? false) as bool,
          },
      };

      final Set<String> displayedSC = {};
      for (var dt in fetchedMap.entries) {
        try {
          final String nameSC = getNameSC(
            subCatIdx: dt.value['subcategory'],
            category: id2Cat(catIdx: dt.value['category']),
          )!;
          displayedSC.add(nameSC);
        } catch (e) {
          print(e);
        }
      }

      final List<Map<String, String>> publications = pubsnapshot.docs.map((
        doc,
      ) {
        final data = doc.data() as Map<String, dynamic>;

        String formattedDate = 'Tanggal tidak tersedia';
        if (data['release_time'] != null && data['release_time'] is Timestamp) {
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
              othersVar: {'displayedSC': displayedSC},
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
              'lib/assets/full-icon-LS.png', // Pastikan nama file sesuai
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
