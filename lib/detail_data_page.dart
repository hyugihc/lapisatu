import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';

import 'package:lapis_satu/notif_try.dart';
import 'package:lapis_satu/atoms/widgets_data.dart';
// import 'package:lapis_satu/atoms/enum_var.dart';

// class DataPage extends StatefulWidget {
//   final Map<String, dynamic> mapData;
//   const DataPage({super.key, required this.mapData});

//   @override
//   State<DataPage> createState() => _DataPageState();
// }

// class _DataPageState extends State<DataPage> {
//   late final List<String> _dataTitles;

//   final List<String> _categoryOptions = [
//     'Semua Kategori',
//     ...Category.values.map(
//       (c) => c.name,
//     ), // -> ['penduduk', 'ekonomi', 'pertanian']
//   ];
//   // State untuk menyimpan kategori yang dipilih (sebagai String)
//   String _selectedCategory = 'Semua Kategori';
//   // --------------------------------------------------

//   Map<Category, List<String>> subCategory = {
//     Category.penduduk: [
//       'Kependudukan dan Migrasi',
//       'Tenaga Kerja',
//       'Pendidikan',
//       'Kesehatan',
//       'Konsumsi dan Pendapatan',
//       'Perlindungan Sosial',
//       'Pemukiman dan Perumahan',
//       'Hukum dan Kriminal',
//       'Budaya',
//       'Aktivitas Politik dan Komunitas Lainnya',
//       'Penggunaan Waktu',
//     ],
//     Category.ekonomi: [
//       'Statistik Makroekonomi',
//       'Neraca Ekonomi',
//       'Statistik Bisnis',
//       'Statistik Sektoral',
//       'Keuangan Pemerintah, Fiskal dan Statistik Sektor Publik',
//       'Perdagangan Internasional dan Neraca Pembayaran',
//       'Harga-Harga',
//       'Biaya Tenaga Kerja',
//       'Ilmu Pengetahuan, Teknologi, dan Inovasi',
//       'Pertanian, Kehutanan, Perikanan',
//       'Energi',
//       'Pertambangan, Manufaktur, Konstruksi',
//       'Transportasi',
//       'Pariwisata',
//       'Perbankan, Asuransi dan Finansial',
//     ],
//     Category.pertanian: [
//       'Lingkungan',
//       'Statistik Regional dan Statistik Area Kecil',
//       'Statistik dan Indikator Multi-Domain',
//       'Buku Tahunan dan Ringkasan Sejenis',
//       'Kondisi Tempat Tinggal, Kemiskinan, dan Permasalahan Sosial Lintas Sektor',
//       'Gender dan Kelompok Populasi Khusus',
//       'Masyarakat Informasi',
//       'Globalisasi',
//       'Indikator Millenium Development Goals (MDGs)',
//       'Perkembangan Berkelanjutan',
//       'Kewiraswastaan',
//     ],
//   };

//   String? _selectedTitle;
//   String _searchKeyword = '';
//   String? _link;

//   @override
//   void initState() {
//     super.initState();
//     _dataTitles = widget.mapData.keys.toList();
//     // Tidak perlu lagi membaca kategori dari mapData
//   }

//   void _showDetail(String title, BuildContext context) {
//     setState(() {
//       _selectedTitle = title;
//       _link = widget.mapData[title]['link'];
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailDataPage(
//             title: _selectedTitle as String,
//             // onBack: _showList,
//             linkData: _link,
//             mapData: widget.mapData,
//           ),
//         ),
//       );
//     });
//   }

//   // void _showList() {
//   //   setState(() {
//   //     _selectedTitle = null;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final filterTitle = _dataTitles.where((title) {
//       final bool matchesCategory;
//       if (_selectedCategory == 'Semua Kategori') {
//         matchesCategory = true;
//       } else {
//         int selectedIndex = Category.values.indexWhere(
//           (c) => c.name == _selectedCategory,
//         );
//         // Bandingkan dengan indeks integer yang ada di data
//         print(selectedIndex);
//         matchesCategory = (widget.mapData[title]['category'] == selectedIndex);
//       }

//       // Kondisi 2: Filter berdasarkan keyword pencarian
//       final matchesSearch = title.toLowerCase().contains(
//         _searchKeyword.toLowerCase(),
//       );

//       final bool isDisplayed;
//       isDisplayed = (widget.mapData[title]['root'] ?? false);
//       // Data akan tampil jika kedua kondisi terpenuhi
//       return matchesCategory && matchesSearch && isDisplayed;
//     }).toList();

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Colors.grey[200],
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             flexibleSpace: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.asset('lib/assets/backgroundd.jpg', fit: BoxFit.cover),
//                 Container(color: Colors.black.withValues(alpha: .3)),
//               ],
//             ),
//             title: Row(
//               children: [
//                 Image.asset('lib/assets/logo bps.png', height: 40),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'BPS Kabupaten Madiun',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Cari Data',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),

//                       // ----------------------------------------------------------
//                       TextField(
//                         decoration: InputDecoration(
//                           hintText: 'cari data tabel disini',
//                           prefixIcon: const Icon(Icons.search),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             _searchKeyword = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 8.0),

//                       DropdownButtonFormField<String>(
//                         initialValue: _selectedCategory,
//                         decoration: InputDecoration(
//                           hintText: 'Pilih Kategori',
//                           prefixIcon: switch (_selectedCategory) {
//                             'penduduk' => Image.asset(
//                               'lib/assets/ic_sosial.png',
//                               width: 10.0,
//                               height: 10.0,
//                             ),
//                             'ekonomi' => Image.asset(
//                               'lib/assets/ic_ekonomi.png',
//                               width: 10.0,
//                               height: 10.0,
//                             ),
//                             'pertanian' => Image.asset(
//                               'lib/assets/ic_pertanian.png',
//                               width: 10.0,
//                               height: 10.0,
//                             ),
//                             _ => Image.asset(
//                               'lib/assets/logo bps.png',
//                               width: 10.0,
//                               height: 10.0,
//                             ),
//                           },
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         // Membuat item dropdown dari list _categoryOptions
//                         items: _categoryOptions.map((String category) {
//                           // Tampilan teks dibuat lebih rapi (huruf pertama kapital)
//                           final displayText =
//                               category[0].toUpperCase() + category.substring(1);
//                           return DropdownMenuItem<String>(
//                             value: category,
//                             child: Text(displayText),
//                           );
//                         }).toList(),
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             setState(() {
//                               _selectedCategory = newValue;
//                             });
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: filterTitle.length,
//                     itemBuilder: (context, index) {
//                       return _buildDataItem(title: filterTitle[index]);
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDataItem({required String title}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: .05),
//             spreadRadius: 1,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () => _showDetail(title, context),
//         borderRadius: BorderRadius.circular(12.0),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               const Icon(Icons.north_east, color: Colors.black54),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class DetailDataPage extends StatefulWidget {
  final String title;
  final String? linkData;
  // final VoidCallback onBack;
  final Map<String, dynamic> mapData;

  const DetailDataPage({
    super.key,
    required this.title,
    // required this.onBack,
    required this.linkData,
    required this.mapData,
  });

  @override
  State<DetailDataPage> createState() => _DetailDataPage();
}

class _DetailDataPage extends State<DetailDataPage> {
  late Future<QuerySnapshot> _kontakFuture;
  final List<String> _namaKolom = [];
  final List<Map<String, dynamic>> _dataRow = [];
  Map<String, dynamic> _atribut = {};
  List<DocumentSnapshot> _documents = [];

  List<String> children = [];

  Future<void> _downloadData({
    required BuildContext context,
    required List<Map<String, dynamic>> dataExc,
    required String title,
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (dataExc.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data untuk diunduh.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Text('Mempersiapkan file Excel...'),
        backgroundColor: Colors.blue[800],
      ),
    );

    try {
      // 1. BUAT OBJEK EXCEL DAN SHEET
      final excel = Excel.createExcel();
      final Sheet sheetObject = excel['Sheet1'];

      // 2. TAMBAHKAN HEADER
      if (dataExc.isNotEmpty) {
        final List<String> headers = dataExc.first.keys.toList();
        sheetObject.appendRow(
          headers.map((header) => TextCellValue(header)).toList(),
        );
      }

      // 3. TAMBAHKAN DATA BARIS
      for (var dataRow in dataExc) {
        final List<dynamic> rowValues = dataRow.values.toList();
        sheetObject.appendRow(
          rowValues.map((value) => TextCellValue(value.toString())).toList(),
        );
      }

      // 4. SIMPAN FILE KE MEMORI (SEBAGAI BYTES)
      // excel.save() mengembalikan List<int>?, kita konversi ke Uint8List
      final List<int>? fileBytesList = excel.save();
      if (fileBytesList == null) {
        throw Exception("Gagal membuat data file Excel.");
      }
      final Uint8List fileBytes = Uint8List.fromList(fileBytesList);

      // 5. MINTA PENGGUNA MEMILIH LOKASI & SIMPAN FILE (HANYA GUNAKAN FileSaver)
      // Buat nama file yang lebih rapi
      String timestamp = DateFormat(
        'yyyy-MM-dd_HH-mm-ss',
      ).format(DateTime.now());
      String fileName = '$title-$timestamp.xlsx';

      // saveAs akan membuka dialog "Save As" agar pengguna bisa memilih lokasi dan nama file
      String? filePath = await FileSaver.instance.saveAs(
        name: fileName,
        bytes: fileBytes,
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );

      if (filePath != null) {
        // Panggil notifikasi setelah file berhasil disimpan
        // Pastikan NotificationService().init() sudah dipanggil sekali saat app pertama kali jalan
        NotificationService().showNotification(
          0,
          'Berhasil diunduh',
          'File disimpan di $filePath',
        );

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('File berhasil disimpan di $filePath'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Pengguna membatalkan dialog simpan
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Penyimpanan file dibatalkan.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // print('Error saat download Excel: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void sortAlgorithm({
    required String sortColumnName,
    required bool ascending,
  }) {
    _dataRow.sort((a, b) {
      final valA = a[sortColumnName];
      final valB = b[sortColumnName];

      if (valA == null) return 1;
      if (valB == null) return -1;

      final int result = (valA.toString()).compareTo(valB.toString());

      return ascending ? result : -result;
    });
  }

  void _onSort(int columnIndex, bool ascending, {bool firstSort = false}) {
    final String sortColumnName = _namaKolom[columnIndex];
    if (firstSort) {
      sortAlgorithm(sortColumnName: sortColumnName, ascending: ascending);
    } else {
      setState(() {
        sortAlgorithm(sortColumnName: sortColumnName, ascending: ascending);
      });
    }
  }

  void _showDetail(String title, BuildContext context) {
    setState(() {
      final link = widget.mapData[title]['link'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailDataPage(
            title: title,
            // onBack: _showList,
            linkData: link,
            mapData: widget.mapData,
          ),
        ),
      );
    });
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
      appBar: generateAppBar(
        title: widget.title,
        onBack: () {
          Navigator.pop(context);
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            tooltip:
                'Download Data', // Opsional, tapi bagus untuk aksesibilitas
            onPressed: () {
              final List<Map<String, dynamic>> dataExc = _documents.map((dt) {
                final data = dt.data() as Map<String, dynamic>;
                return {for (var col in _namaKolom) col: data[col]};
              }).toList();
              _downloadData(
                context: context,
                dataExc: dataExc,
                title: widget.title,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _kontakFuture,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan!'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Belum ada data / Atau Kemungkinan ada kesalahan!'),
            );
          }

          if (_documents.isEmpty) {
            _documents = snapshot.data!.docs;
            for (var doc in _documents) {
              if (doc.id == 'atribut') {
                _atribut = doc.data() as Map<String, dynamic>;
              } else {
                _dataRow.add(doc.data() as Map<String, dynamic>);
              }
            }
            for (var col in _atribut['column']) {
              _namaKolom.add(col.keys.first);
            }
            final dynamic childrenData = _atribut['children'];

            // 1. Pengecekan keamanan (Safety check) - Ini WAJIB
            if (childrenData is List && childrenData.isNotEmpty) {
              // 2. Siapkan 'daftar belanja' ID. Ini sudah benar.
              final childIdSet = childrenData.toSet();

              // 3. INI BAGIAN PENTINGNYA
              children = widget
                  .mapData
                  .entries // <-- Pakai .entries, BUKAN .values
                  .where((entry) => childIdSet.contains(entry.value['id']))
                  .map((entry) => entry.key)
                  .toList();
            }
            _onSort(0, true, firstSort: true);
          }

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
                      fontSize: 24,
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
                    child: DesignedTableData(
                      atribute: _atribut,
                      data: _dataRow,
                    ),
                  ),

                  if (children.isNotEmpty)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // clipBehavior agar efek 'mekar'-nya tetap di dalam Card
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        // Ini adalah 'tombol' yang selalu terlihat
                        title: Text(
                          'Lihat Data Pendukung',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Terdapat ${children.length} data pendukung',
                        ), // Opsional
                        leading: Icon(Icons.dataset_linked_outlined),
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: children.length,
                              itemBuilder: (context, index) {
                                return _buildDataItem(title: children[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                  Text(
                    _atribut['chart'] == null ? '' : 'Tampilan Diagram',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  switch (_atribut['chart']) {
                    0 => DesignedBarChart(data: _dataRow, atribute: _atribut),
                    1 => DesignedLineChart(data: _dataRow, atribute: _atribut),
                    _ => SizedBox(height: 10),
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, String>>> fetchDocsByIds(List<String> docIds) async {
    if (docIds.isEmpty) {
      return [];
    }

    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('/data-umum/title/list_title/')
        .where(FieldPath.documentId, whereIn: docIds)
        .get();

    final listHasil = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, String>;
      return data;
    }).toList();

    return listHasil;
  }

  Widget _buildDataItem({required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          return _showDetail(title, context);
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
