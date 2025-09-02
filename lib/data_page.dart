import 'package:flutter/material.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  final List<String> _dataTitles = const [
    'Data Tingkat Pengangguran Terbuka 2025',
    'Data PDRB per Kapita Kabupaten Madiun',
    'Indeks Pembangunan Manusia (IPM) 2025',
    'Data Laju Pertumbuhan Penduduk',
    'Garis Kemiskinan per Kapita per Bulan',
    'Indeks Kedalaman Kemiskinan (P1)',
    'Indeks Keparahan Kemiskinan (P2)',
    'Rata-rata Lama Sekolah (RLS)',
    'Angka Harapan Hidup (AHH)',
    'Data Produksi Padi dan Palawija',
    'Luas Lahan Pertanian',
    'Data Seks Bebas di Madiun',
    'Tingkat Kehamilan diluar nikah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Stack(
          children: [
            Image.asset(
              'lib/assets/backgroundd.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            SafeArea(
              child: SizedBox(
                height: kToolbarHeight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'lib/assets/logo bps.png',
                          height: 50,
                          width: 50,
                          ),
                          const SizedBox(width: 8),
                          const Text('BPS Kabupaten Madiun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
                          shadows: [Shadow(blurRadius: 4.0, color: Colors.black54),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]
                )
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Cari Data', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height:8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'cari data tabel disini...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ), 
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dataTitles.length,
                itemBuilder: (context, index) {
                  return _buildDataItem(title: _dataTitles[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem({required String title}) {
    return Container (
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ]
      ),
      child: InkWell(
        onTap: () {
          print('Clicked on $title');
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                const Icon(Icons.north_east, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}