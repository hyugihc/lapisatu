import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';

import 'dart:math';

import 'package:lapis_satu/notif_try.dart';

class DataPage extends StatefulWidget {
  final Map<String, String> mapData;
  const DataPage({super.key, required this.mapData});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late final List<String> _dataTitles;

  String? _selectedTitle;
  String _searchKeyword = '';
  String? _link;

  @override
  void initState() {
    super.initState();
    _dataTitles = widget.mapData.keys.toList();
  }

  void _showDetail(String title, BuildContext context) {
    setState(() {
      _selectedTitle = title;
      _link = widget.mapData[title];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailDataPage(
            title: _selectedTitle as String,
            onBack: _showList,
            linkData: _link,
          ),
        ),
      );
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
          body: SingleChildScrollView(
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
        onTap: () => _showDetail(title, context),
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
  List<DocumentSnapshot> _documents = [];
  bool _isDisplayChart = true;

  int? _sortColumnIndex;
  bool _isSortAscending = true;

  Future<void> _downloadData({
    required BuildContext context,
    required List<Map<String, dynamic>> dataExc,
    required String title,
  }) async {
    // Tampilkan notifikasi awal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mempersiapkan file Excel...'),
        backgroundColor: Colors.blue[800],
      ),
    );

    // Lakukan validasi, jangan proses jika tidak ada data
    if (dataExc.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada data untuk diunduh.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // 1. BUAT OBJEK EXCEL DAN SHEET
      final excel = Excel.createExcel();
      final Sheet sheetObject = excel['Sheet1'];

      // 2. TAMBAHKAN HEADER SECARA OTOMATIS
      // Mengambil kunci (nama kolom) dari data pertama sebagai header
      final List<String> headers = dataExc.first.keys.toList();
      sheetObject.appendRow(
        headers.map((header) => TextCellValue(header)).toList(),
      );

      // 3. TAMBAHKAN DATA BARIS
      for (var dataRow in dataExc) {
        // Mengambil nilai dari setiap baris data
        final List<dynamic> rowValues = dataRow.values.toList();
        sheetObject.appendRow(
          rowValues.map((value) => TextCellValue(value.toString())).toList(),
        );
      }

      // 4. SIMPAN FILE KE PERANGKAT
      final Uint8List? fileBytes = excel.save() as Uint8List?;

      if (fileBytes != null) {
        String timestamp = DateTime.now().toIso8601String().replaceAll(
          ':',
          '-',
        );
        String fileName = '$title$timestamp.xlsx';

        // Gunakan file_saver untuk memunculkan dialog simpan
        String filePath = await FileSaver.instance.saveFile(
          name: fileName,
          bytes: fileBytes,
          fileExtension: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
        NotificationService().init();
        NotificationService().showNotification(
          0,
          'Berhasil di Download',
          'File disimpan di $filePath',
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil disimpan di $filePath'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error saat download Excel: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, String> _findColumnFitName({
    required Map<String, dynamic> dataFirst,
  }) {
    String xLabel = '';
    String yCol = '';

    for (var col in _namaKolom) {
      if (dataFirst[col].runtimeType == String) {
        xLabel = col;
        break;
      } else if (dataFirst[col] is num) {
        yCol = col;
      }
    }
    if (xLabel.isEmpty) {
      for (var kol in _namaKolom) {
        if (kol.toLowerCase() == 'tahun' || kol.toLowerCase() == 'year') {
          xLabel = kol;
          break;
        }
      }
    }
    return {'xlabel': xLabel, 'ylabel': yCol};
  }

  BarChartDataBundle transformSnapshotToBarData({
    required List<DocumentSnapshot> dokumen,
  }) {
    if (dokumen.isEmpty) {
      return BarChartDataBundle(barGroups: [], bottomTitles: []);
    }

    List<BarChartGroupData> barGroups = [];
    List<String> bottomTitles = [];
    final Map<String, dynamic> firstData =
        dokumen.first.data() as Map<String, dynamic>;

    final Map<String, String> xyLabel = _findColumnFitName(
      dataFirst: firstData,
    );
    // Looping melalui setiap dokumen beserta indeksnya
    dokumen.asMap().entries.forEach((entry) {
      int index = entry.key;
      var doc = entry.value;
      final data = doc.data() as Map<String, dynamic>;

      // 1. Sumbu X SELALU menggunakan indeks (0, 1, 2, ...)
      final int xValue = index;
      final double yValue =
          (data[xyLabel['ylabel']] as num?)?.toDouble() ?? 0.0;

      // Tambahkan data bar ke list barGroups
      barGroups.add(
        BarChartGroupData(
          x: xValue,
          showingTooltipIndicators: [0],
          barRods: [
            BarChartRodData(
              toY: yValue,
              color: Colors.lightBlue,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );

      // 2. Tentukan LABEL untuk sumbu X
      if (xyLabel['xlabel']!.isNotEmpty) {
        bottomTitles.add(data[xyLabel['xlabel']].toString());
      } else {
        bottomTitles.add(index.toString());
      }
    });

    // Kembalikan "paket" yang berisi kedua list tersebut
    return BarChartDataBundle(barGroups: barGroups, bottomTitles: bottomTitles);
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isSortAscending = ascending;

      final String sortColumnName = _namaKolom[columnIndex];

      _documents.sort((a, b) {
        final dataA = a.data() as Map<String, dynamic>;
        final dataB = b.data() as Map<String, dynamic>;

        // Ambil value, perhatikan jika ada dokumen yang tidak punya kolom ini (akan bernilai null)
        final valA = dataA[sortColumnName];
        final valB = dataB[sortColumnName];

        // Atur agar baris dengan data null selalu di bawah
        if (valA == null) return 1;
        if (valB == null) return -1;

        // Gunakan compareTo untuk sorting
        final int result = (valA.toString()).compareTo(valB.toString());

        return ascending ? result : -result;
      });
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
          onPressed: () {
            widget.onBack;
            Navigator.of(context).pop();
          },
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
            return const Center(
              child: Text('Belum ada data / Atau Kemungkinan ada kesalahan!'),
            );
          }
          if (_documents.isEmpty) {
            _documents = snapshot.data!.docs;
          }
          Map<String, dynamic> dataColumns =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          _namaKolom = dataColumns.keys.toList();

          List<DataRow> dataRows = _documents.asMap().entries.map((entry) {
            int index = entry.key;
            DocumentSnapshot document = entry.value;
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (index.isEven) {
                  return Colors.grey.withValues(alpha: .1);
                }
                return null;
              }),
              cells: _namaKolom.map((kolom) {
                return DataCell(
                  Center(child: Text((data[kolom] ?? '-').toString())),
                );
              }).toList(),
            );
          }).toList();
          BarChartDataBundle? chartData;
          List<double>? yValues;
          double? minYValue;
          double? maxYValue;
          double? paddingY;

          try {
            chartData = transformSnapshotToBarData(dokumen: _documents);

            yValues = chartData.barGroups
                .map((group) => group.barRods.first.toY)
                .toList();
            minYValue = yValues.reduce(min);
            maxYValue = yValues.reduce(max);

            if (minYValue == maxYValue) {
              paddingY = minYValue * 0.5;
            } else {
              final range = maxYValue - minYValue;
              paddingY = range * 0.5;
            }
          } catch (e) {
            _isDisplayChart = false;
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
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _isSortAscending,
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
                                onSort: _onSort,
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
                      onPressed: () {
                        final List<Map<String, dynamic>> dataExc =
                            snapshot.data?.docs.map((dt) {
                              final data = dt.data() as Map<String, dynamic>;
                              return {
                                    for (var col in _namaKolom)
                                      {col: data[col]},
                                  }
                                  as Map<String, dynamic>;
                            }).toList() ??
                            [];
                        _downloadData(
                          context: context,
                          dataExc: dataExc,
                          title: widget.title,
                        );
                      },

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
                  Text(
                    _isDisplayChart
                        ? 'Tempilan Diagram'
                        : 'Tidak ada Tampilan Chart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_isDisplayChart)
                    Card(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) =>
                                      Colors.transparent,
                                  tooltipPadding: EdgeInsets.zero,
                                ),
                              ),
                              minY: (minYValue! - paddingY!).floorToDouble() < 0
                                  ? 0
                                  : (minYValue - paddingY).floorToDouble(),
                              maxY: (maxYValue! + paddingY).ceilToDouble(),
                              alignment: BarChartAlignment.spaceEvenly,
                              barGroups: chartData!.barGroups,
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                          final String title = chartData!
                                              .bottomTitles[value.toInt()];
                                          return SideTitleWidget(
                                            meta: meta,
                                            child: Text(title),
                                          );
                                        },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BarChartDataBundle {
  final List<BarChartGroupData> barGroups;
  final List<String> bottomTitles;

  BarChartDataBundle({required this.barGroups, required this.bottomTitles});
}
