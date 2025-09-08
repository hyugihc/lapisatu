import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool _isLoading = true;
  Map<String, String> _mapData = {};
  List<String> _dataTitles = [];

  String? _selectedTitle;
  String _searchKeyword = '';
  String? _link;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Panggil fungsi untuk mengambil data saat widget pertama kali dibuat
  }

  // === FUNGSI BARU UNTUK MENGAMBIL DATA DARI FIRESTORE ===
  Future<void> _fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(
            '/data-umum/title/list_title/',
          ) // Sesuaikan dengan path Anda
          .get();
      print(snapshot.docs.isEmpty);

      final fetchedMap = {
        for (var doc in snapshot.docs)
          (doc['judul'] as String): (doc['link'] as String),
      };

      setState(() {
        _mapData = fetchedMap;
        _dataTitles = _mapData.keys.toList(); // Ambil semua judul dari keys Map
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = true; // Hentikan loading jika ada error
        // Anda bisa menambahkan logic untuk menampilkan pesan error di sini
      });
    }
  }

  void _showDetail(String title) {
    setState(() {
      _selectedTitle = title;
      _link = _mapData[title];
    });
  }

  void _showList() {
    setState(() {
      _selectedTitle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterTitle = _dataTitles
        .where(
          (title) => title.toLowerCase().contains(_searchKeyword.toLowerCase()),
        )
        .toList();

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
                Container(color: Colors.black.withValues(alpha: 0.3)),
              ],
            ),
            title: Row(
              children: [
                Image.asset('lib/assets/logo bps.png', height: 40),
                const SizedBox(width: 8),
                const Text(
                  'BPS Kabupaten Madiun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cari Data',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'cari data tabel disini',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchKeyword = value;
                                });
                              },
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
              linkData: _link,
            ),
          ),
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
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
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

class DetailDataPage extends StatefulWidget {
  final String title;
  final String? linkData;
  final VoidCallback onBack;
  const DetailDataPage({
    super.key,
    required this.title,
    required this.onBack,
    required this.linkData,
  });

  @override
  State<DetailDataPage> createState() => _DetailDataPage();
}

class _DetailDataPage extends State<DetailDataPage> {
  late Future<QuerySnapshot> _kontakFuture;
  List<String> _namaKolom = [];

  void _downloadData(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Mendownload data... (simulasi)'),
      backgroundColor: Colors.blue[800],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _kontakFuture = FirebaseFirestore.instance
        .collection(widget.linkData as String)
        .get();
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
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _kontakFuture, // Gunakan Future yang sudah dideklarasikan
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // 1. Menangani state Error
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan!'));
          }

          // 2. Menangani state Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Jika tidak ada data
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada data.'));
          }

          Map<String, dynamic> dataColumns =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          _namaKolom = dataColumns.keys.toList();

          List<DataRow> dataRows = snapshot.data!.docs.asMap().entries.map((
            entry,
          ) {
            // Menggunakan asMap().entries.map() untuk mendapatkan index
            int index = entry.key;
            DocumentSnapshot document = entry.value;
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return DataRow(
              // Memberi warna selang-seling pada baris
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (index.isEven) {
                  // Warna untuk baris genap (indeks 0, 2, 4, ...)
                  return Colors.grey.withValues(alpha: .1);
                }
                // Baris ganjil akan transparan (default)
                return null;
              }),
              cells: _namaKolom.map((kolom) {
                return DataCell(
                  Center(
                    // Gunakan 'kolom' sebagai kunci untuk mengambil data secara dinamis
                    child: Text((data[kolom] ?? '-').toString()),
                  ),
                );
              }).toList(),
            );
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Mencegah konten di dalam Card keluar dari sudut yang melengkung
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        Expanded(
                          child: DataTable(
                            // ======== DEKORASI HEADER ========
                            headingRowColor: WidgetStateProperty.all(
                              Colors.blue[700],
                            ), // Warna latar header
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Warna teks header
                              fontSize: 16,
                            ),

                            // ======== GARIS BATAS & SPASI ========
                            border: TableBorder.all(
                              width: 1,
                              color:
                                  Colors.grey.shade300, // Warna garis batas sel
                              borderRadius: BorderRadius.circular(
                                11,
                              ), // Sesuaikan dengan radius Card
                            ),
                            horizontalMargin:
                                0, // Hapus margin bawaan di kiri dan kanan
                            columnSpacing: 16,

                            // ======== KOLOM (HEADER) ========
                            columns: _namaKolom.map((String columnName) {
                              return DataColumn(
                                label: Expanded(
                                  child: Center(
                                    child: Text(
                                      columnName,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            // ======== BARIS DATA ========
                            rows: dataRows,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadData(context),

                      icon: const Icon(Icons.download),
                      label: const Text('Download Data'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
