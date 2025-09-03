import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  static const List<String> dataTitles = [
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
    'Luas Rumah Repok',
  ];

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  String? _selectedTitle;
  String _searchKeyword = '';

  void _showDetail(String title) {
    setState(() {
      _selectedTitle = title;
    });
  }

  void _showList() {
    setState(() {
      _selectedTitle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterTitle = DataPage.dataTitles.where((title) =>
      title.toLowerCase().contains(_searchKeyword.toLowerCase())
    ).toList();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('lib/assets/backgroundd.jpg', fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.3)),
              ],
            ),
            title: Row(
              children: [
                Image.asset('lib/assets/logo bps.png', height: 40),
                const SizedBox(width: 8),
                const Text('BPS Kabupaten Madiun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cari Data', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'cari data tabel disini',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0), 
                            borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchKeyword = value;
                          });
                        }
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filterTitle.length,
                    itemBuilder: (context, index) {
                      return _buildDataItem(title: filterTitle[index]);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        
        if (_selectedTitle != null)
          Positioned.fill(
            child: DetailDataPage(
              title: _selectedTitle!,
              onBack: _showList,
            ),
          )
      ],
    );
  }

  Widget _buildDataItem({required String title}) {
    return Container(
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
        ],
      ),
      child: InkWell(
        onTap: () => _showDetail(title),
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


class DetailDataPage extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const DetailDataPage({super.key, required this.title, required this.onBack});

  void _downloadData(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Mendownload data... (simulasi)'),
      backgroundColor: Colors.blue[800],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    appBar: AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/assets/backgroundd.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.3)),
        ],
      ),
      title: const Text(
        'Tabel Data',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),

      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack,
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'belum ada tabel data',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _downloadData(context),

                icon: const Icon(Icons.download),
                label: const Text('Download Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),            
            const Text(
              'Tabel Terkait',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('Tidak ada tabel terkait.'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}