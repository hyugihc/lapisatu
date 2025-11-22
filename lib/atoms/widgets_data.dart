// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:data_table_2/data_table_2.dart';
import 'dart:math';

import 'package:lapis_satu/atoms/enum_var.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';
import 'package:photo_view/photo_view.dart';

// ========== DATA TEMPLATE ==========
class DesignedTableData extends StatefulWidget {
  final Map<String, dynamic> atribute;
  final List<Map<String, dynamic>> data;
  final bool isPreviewMode;
  final Map<String, Function>? functionList;
  const DesignedTableData({
    super.key,
    required this.atribute,
    required this.data,
    this.isPreviewMode = false,
    this.functionList,
  });

  @override
  State<DesignedTableData> createState() {
    return _DesignedTableData();
  }
}

class _DesignedTableData extends State<DesignedTableData> {
  late List<Map<String, dynamic>> _columnStructure;
  late int _totalColumns;

  int? _sortColumnIndex;
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    _columnStructure = List<Map<String, dynamic>>.from(
      widget.atribute['column'],
    );
    _totalColumns = _columnStructure.length - 1;
    _onSort(0, false, firstSort: true);
    // print(widget.data);
  }

  void sortAlgorithm(int columnIndex, bool ascending) {
    _sortColumnIndex = columnIndex;
    _isSortAscending = ascending;

    final String sortColumnName = _columnStructure[columnIndex].keys.first;

    widget.data.sort((a, b) {
      final valA = a[sortColumnName];
      final valB = b[sortColumnName];

      if (valA == null && valB == null) return 0;
      if (valA == null) return 1;
      if (valB == null) return -1;

      int result;
      if (valA is Comparable && valB is Comparable) {
        result = valA.compareTo(valB);
      } else {
        result = valA.toString().compareTo(valB.toString());
      }
      return ascending ? result : -result;
    });
  }

  void _onSort(int columnIndex, bool ascending, {bool firstSort = false}) {
    if (firstSort) {
      sortAlgorithm(columnIndex, ascending);
    } else {
      setState(() {
        sortAlgorithm(columnIndex, ascending);
      });
    }
  }

  List<DataColumn> _buildColumns() {
    final tempList = _columnStructure
        .map(
          (val) => DataColumn2(
            onSort: _onSort,
            label: Center(
              child: val.keys.first == 'id_row'
                  ? const Text('')
                  : Text(val.keys.first),
            ),
            fixedWidth: val.keys.first == 'id_row'
                ? 30
                : val.values.first == 4
                ? 60
                : val.values.first == 3
                ? 90
                : null,
          ),
        )
        .toList();
    if (widget.isPreviewMode) {
      tempList.add(
        DataColumn2(label: Center(child: Text('Aksi')), fixedWidth: 120),
      );
    }
    return tempList;
  }

  String _formatDisplayValue({required DataType tipe, required dynamic value}) {
    if (value is Timestamp) {
      value = value.toDate();
    }
    if (value == null) {
      return '';
    }
    switch (tipe) {
      case DataType.integer:
        return value.toString();
      case DataType.float:
        return value.toString().replaceAll('.', ',');
      case DataType.string:
        return value.toString();
      case DataType.datetime:
        return DateFormat('dd-MM-yyyy HH:mm').format(value);
      case DataType.year:
        value = value.toInt();
        return value.toString();
      case DataType.month:
        if (value is int) return value.toString();
        return DateFormat('MMMM', 'id_ID').format(value);
      case DataType.date:
        return DateFormat('dd-MM-yyyy').format(value);
      case DataType.money:
        return 'Rp. ${value.toString().replaceAll('.', ',')}';
    }
  }

  List<DataRow> _buildRows() {
    // Menggunakan List.generate untuk mendapatkan index baris
    return List.generate(widget.data.length, (index) {
      final row = widget.data[index];
      return DataRow2(
        // Menambahkan warna selang-seling untuk kemudahan membaca
        color: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (index.isEven) {
            return Colors.blue.shade50.withValues(alpha: 0.5);
          }
          return null;
        }),
        cells: [
          ..._columnStructure.map((val) {
            return DataCell(
              Center(
                child: Text(
                  _formatDisplayValue(
                    tipe: DataType.values[val.values.first],
                    value: row[val.keys.first],
                  ),
                ),
              ),
            );
          }),
          if (widget.isPreviewMode)
            DataCell(
              Row(
                mainAxisSize:
                    MainAxisSize.min, // Agar row tidak makan banyak tempat
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit',
                    onPressed: () {
                      widget.functionList!['edit']!(idx: index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus',
                    onPressed: () {
                      widget.functionList!['delete']!(idx: index);
                    },
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  int _isIdRowExist() {
    for (var col in widget.atribute['column']) {
      if (col.keys.first == 'id_row') {
        return 1;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: DataTable2(
            fixedLeftColumns: _isIdRowExist(),
            fixedTopRows: 1,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: widget.isPreviewMode
                ? (90 * _totalColumns) + 140
                : (90 * _totalColumns) + 20,
            headingRowColor: WidgetStateProperty.all(Colors.blue),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _isSortAscending,
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }
}

class DesignedBarChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Map<String, dynamic> atribute;
  const DesignedBarChart({
    super.key,
    required this.data,
    required this.atribute,
  });

  @override
  State<DesignedBarChart> createState() => _DesignedBarChart();
}

class _DesignedBarChart extends State<DesignedBarChart> {
  final Map<String, dynamic> _atributeChart = {};
  late final Map<String, List> _recomColumn;

  int _selectedXIndex = 0;
  int _selectedYIndex = 0;

  @override
  void initState() {
    _recomColumn = _findColumnFitName();
    super.initState();
  }

  Map<String, List> _findColumnFitName() {
    List<String> xLabel = [];
    List<String> yCol = [];

    for (var col in (widget.atribute['column'])) {
      var tempvar = DataType.values[col.values.first as int];
      if (col.keys.first == 'id_row') {
        continue;
      }
      if ([
        DataType.string,
        DataType.year,
        DataType.month,
        DataType.date,
      ].contains(tempvar)) {
        xLabel.add(col.keys.first);
      } else if ([
        DataType.integer,
        DataType.float,
        DataType.money,
      ].contains(tempvar)) {
        yCol.add(col.keys.first);
      }
    }
    Map<String, List> xyLabel = {'xlabel': xLabel, 'ylabel': yCol};
    return xyLabel;
  }

  BarChartDataBundle transformDataToBarData({
    required List<Map<String, dynamic>> data,
    required int idkX,
    required int idkY,
  }) {
    if (data.isEmpty) {
      return BarChartDataBundle(barGroups: [], bottomTitles: []);
    }

    if (_recomColumn['xlabel']!.isEmpty || _recomColumn['ylabel']!.isEmpty) {
      return BarChartDataBundle(barGroups: [], bottomTitles: []);
    }

    List<BarChartGroupData> barGroups = [];
    List<String> bottomTitles = [];
    String xLabel = _recomColumn['xlabel']![idkX];
    String yLabel = _recomColumn['ylabel']![idkY];

    sortListMaps(data: data, colName: xLabel, ascending: true);

    data.asMap().entries.forEach((entry) {
      int index = entry.key;
      final data = entry.value;

      final int xValue = index;
      final double yValue = (data[yLabel] as num?)?.toDouble() ?? 0.0;

      barGroups.add(
        BarChartGroupData(
          x: xValue,
          showingTooltipIndicators: [0],
          barRods: [
            BarChartRodData(
              toY: yValue,
              color: Colors.lightBlue,
              width: 25,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
      if (xLabel.isNotEmpty) {
        final String display;
        if (data[xLabel] is num) {
          display = data[xLabel].toInt().toString();
        } else if (data[xLabel] is DateTime || data[xLabel] is Timestamp) {
          if (data[xLabel] is Timestamp) {
            data[xLabel].toDate();
          }
          display = DateFormat('MMMM', 'id_ID').format(data[xLabel]);
        } else {
          display = data[xLabel].toString();
        }
        bottomTitles.add(display);
      } else {
        bottomTitles.add(index.toString());
      }
    });
    return BarChartDataBundle(barGroups: barGroups, bottomTitles: bottomTitles);
  }

  void computeChartAtribute() {
    final BarChartDataBundle chartData;
    final List<double> yValues;
    final double minYValue;
    final double maxYValue;
    final double paddingY;
    final double minYChart;
    final double maxYChart;

    chartData = chartData = transformDataToBarData(
      data: widget.data,
      idkX: _selectedXIndex,
      idkY: _selectedYIndex,
    );

    yValues = chartData.barGroups
        .map((group) => group.barRods.first.toY)
        .toList();

    if (yValues.isEmpty) {
      _atributeChart['chartData'] = chartData;
      _atributeChart['minY'] = 0.0;
      _atributeChart['maxY'] = 10.0; // Nilai default
      return; // Hentikan fungsi
    }
    minYValue = yValues.reduce(min);
    maxYValue = yValues.reduce(max);

    if (minYValue == maxYValue) {
      paddingY = minYValue * 0.3;
    } else {
      paddingY = (maxYValue - minYValue) * 0.5;
    }

    if ((minYValue - paddingY).floorToDouble() < 0) {
      // minYChart = (minYValue - paddingY).floorToDouble();
      minYChart = 0;
    } else {
      minYChart = (minYValue - paddingY).floorToDouble();
    }

    maxYChart = (maxYValue + paddingY).ceilToDouble();

    _atributeChart['chartData'] = chartData;
    _atributeChart['minY'] = minYChart;
    _atributeChart['maxY'] = maxYChart;
  }

  Widget _buildControls() {
    // Ambil list nama kolom
    List<String> xLabels = _recomColumn['xlabel']?.cast<String>() ?? [];
    List<String> yLabels = _recomColumn['ylabel']?.cast<String>() ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- DROPDOWN UNTUK X-AXIS ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sumbu X (Label)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedXIndex,
                  isExpanded: true,
                  // Ubah list String ['Tahun', 'Bulan'] menjadi DropdownMenuItem
                  items: xLabels.asMap().entries.map((entry) {
                    // entry.key = index (0, 1, 2, ...)
                    // entry.value = nama kolom ('Tahun')
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: xLabels.isEmpty
                      ? null // Disable jika tidak ada opsi
                      : (newIndex) {
                          setState(() {
                            _selectedXIndex = newIndex!;
                            sortListMaps(
                              data: widget.data,
                              colName: xLabels[newIndex],
                              ascending: true,
                            );
                          });
                        },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // --- DROPDOWN UNTUK Y-AXIS ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sumbu Y (Nilai)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedYIndex,
                  isExpanded: true,
                  items: yLabels.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: yLabels.isEmpty
                      ? null // Disable jika tidak ada opsi
                      : (newIndex) {
                          setState(() {
                            _selectedYIndex = newIndex!;
                          });
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      computeChartAtribute();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControls(),
          Card(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  top: 30,
                ),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          // Cek apakah nilai Y adalah 0
                          if (value == 0) {
                            return FlLine(
                              // Tampilkan garis yang tebal dan berwarna merah
                              color: Colors.red,
                              strokeWidth: 2,
                            );
                          }

                          // Untuk nilai Y lainnya, gunakan garis standar (atau sembunyikan)
                          return FlLine(
                            color: Colors.grey.withValues(alpha: .3),
                            strokeWidth: 0.5,
                          );
                        },
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.transparent,
                          tooltipPadding: EdgeInsets.zero,
                        ),
                      ),
                      minY: _atributeChart['minY'] as double,
                      maxY: _atributeChart['maxY'] as double,
                      alignment: BarChartAlignment.spaceEvenly,
                      barGroups: _atributeChart['chartData'].barGroups,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final String title = _atributeChart['chartData']
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
                      borderData: FlBorderData(show: false),
                      // gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      // print(e);
      return const SizedBox.shrink();
    }
  }
}

class DesignedLineChart extends StatefulWidget {
  // Asumsi widget Anda menerima parameter ini
  final List<Map<String, dynamic>> data;
  final Map<String, dynamic> atribute;

  const DesignedLineChart({
    super.key,
    required this.data,
    required this.atribute,
  });

  @override
  State<DesignedLineChart> createState() => _DesignedLineChartState();
}

class _DesignedLineChartState extends State<DesignedLineChart> {
  final Map<String, dynamic> _atributeChart = {};
  late final Map<String, List> _recomColumn;

  int _selectedXIndex = 0;
  int _selectedYIndex = 0;

  @override
  void initState() {
    // Pastikan _findColumnFitName dipanggil sebelum super.initState()
    // jika _recomColumn digunakan di build() pertama kali.
    _recomColumn = _findColumnFitName();
    super.initState();
  }

  // --- Fungsi ini TIDAK BERUBAH ---
  // Logika Anda untuk menemukan kolom X dan Y sudah benar.
  Map<String, List> _findColumnFitName() {
    List<String> xLabel = [];
    List<String> yCol = [];

    // Pastikan 'widget.atribute['column']' adalah List<Map<String, dynamic>>
    // atau sesuai dengan struktur data Anda.
    // Di sini saya asumsikan formatnya List<Map<String, int>>
    for (var col in (widget.atribute['column'] as List)) {
      var tempvar = DataType.values[col.values.first as int];
      if (col.keys.first == 'id_row') {
        continue;
      }
      if ([
        DataType.string,
        DataType.year,
        DataType.month,
        DataType.date,
      ].contains(tempvar)) {
        xLabel.add(col.keys.first);
      } else if ([
        DataType.integer,
        DataType.float,
        DataType.money,
      ].contains(tempvar)) {
        yCol.add(col.keys.first);
      }
    }
    Map<String, List> xyLabel = {'xlabel': xLabel, 'ylabel': yCol};
    return xyLabel;
  }

  LineChartDataBundle transformDataToLineData({
    required List<Map<String, dynamic>> data,
    required int idkX,
    required int idkY,
  }) {
    if (data.isEmpty) {
      return LineChartDataBundle(lineBarsData: [], bottomTitles: []);
    }

    if (_recomColumn['xlabel']!.isEmpty || _recomColumn['ylabel']!.isEmpty) {
      return LineChartDataBundle(lineBarsData: [], bottomTitles: []);
    }

    List<FlSpot> spots = []; // <- Berubah dari BarChartGroupData
    List<String> bottomTitles = [];
    String xLabel = _recomColumn['xlabel']![idkX];
    String yLabel = _recomColumn['ylabel']![idkY];

    sortListMaps(data: data, colName: xLabel, ascending: true);

    data.asMap().entries.forEach((entry) {
      int index = entry.key;
      final data = entry.value;

      // Untuk LineChart, 'x' adalah nilai numerik. Kita gunakan index.
      final double xValue = index.toDouble();
      final double yValue = (data[yLabel] as num?)?.toDouble() ?? 0.0;
      spots.add(FlSpot(xValue, yValue));

      if (xLabel.isNotEmpty) {
        final String display;

        // print(data[xLabel]);
        // print(DateFormat('MMMM', 'id_ID').format(data[xLabel]));
        if (data[xLabel] is num) {
          display = data[xLabel].toInt().toString();
        } else if (data[xLabel] is DateTime || data[xLabel] is Timestamp) {
          if (data[xLabel] is Timestamp) {
            display = DateFormat('MMMM', 'id_ID').format(data[xLabel].toDate());
          } else {
            display = DateFormat('MMMM', 'id_ID').format(data[xLabel]);
          }
        } else {
          display = data[xLabel].toString();
        }
        bottomTitles.add(display);
      } else {
        bottomTitles.add(index.toString());
      }
    });

    // Buat satu LineChartBarData yang berisi semua spots
    final lineBarData = LineChartBarData(
      spots: spots,
      isCurved: false,
      color: const Color.fromRGBO(3, 169, 244, 1),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 7,
          color: Colors.lightBlue,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
    );

    return LineChartDataBundle(
      lineBarsData: [lineBarData], // Kembalikan sebagai list
      bottomTitles: bottomTitles,
    );
  }

  // --- [DIUBAH] Fungsi computeChartAtribute ---
  // Hanya mengubah cara mengambil yValues
  void computeChartAtribute() {
    final LineChartDataBundle chartData; // <- Diubah
    final List<double> yValues;
    final double minYValue;
    final double maxYValue;
    final double paddingY;
    double minYChart;
    final double maxYChart;

    chartData = transformDataToLineData(
      data: widget.data,
      idkX: _selectedXIndex,
      idkY: _selectedYIndex,
    );

    // Ambil yValues dari spots, bukan barGroups
    yValues = (chartData.lineBarsData.isEmpty)
        ? []
        : chartData.lineBarsData.first.spots.map((spot) => spot.y).toList();

    if (yValues.isEmpty) {
      _atributeChart['chartData'] = chartData;
      _atributeChart['minY'] = 0.0;
      _atributeChart['maxY'] = 10.0; // Nilai default
      return; // Hentikan fungsi
    }
    minYValue = yValues.reduce(min);
    maxYValue = yValues.reduce(max);

    // Sisa logika perhitungan min/max Y Anda TIDAK BERUBAH
    if (minYValue == maxYValue) {
      paddingY = (minYValue == 0 ? 10 : minYValue) * 0.5; // Hindari 0 * 0.5
    } else {
      paddingY = (maxYValue - minYValue) * 0.1;
    }

    // if ((minYValue - paddingY).floorToDouble() < 0) {
    //   minYChart = 0;
    // } else {
    //   minYChart = (minYValue - paddingY).floorToDouble();
    // }
    minYChart = (minYValue - paddingY).floorToDouble();

    maxYChart = (maxYValue + paddingY).ceilToDouble();

    // Pastikan min dan max tidak sama (menyebabkan error di fl_chart)
    if (minYChart == maxYChart) {
      minYChart = 0;
    }

    _atributeChart['chartData'] = chartData;
    _atributeChart['minY'] = minYChart;
    _atributeChart['maxY'] = maxYChart;
  }

  Widget _buildControls() {
    // Ambil list nama kolom
    List<String> xLabels = _recomColumn['xlabel']?.cast<String>() ?? [];
    List<String> yLabels = _recomColumn['ylabel']?.cast<String>() ?? [];

    // Jika xLabels atau yLabels kosong, tampilkan pesan
    if (xLabels.isEmpty || yLabels.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            xLabels.isEmpty
                ? 'Tidak ditemukan kolom teks/tanggal (Sumbu X)'
                : 'Tidak ditemukan kolom angka (Sumbu Y)',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- DROPDOWN UNTUK X-AXIS ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sumbu X (Label)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedXIndex,
                  isExpanded: true,
                  items: xLabels.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: xLabels.isEmpty
                      ? null // Disable jika tidak ada opsi
                      : (newIndex) {
                          setState(() {
                            _selectedXIndex = newIndex!;
                            // Panggil sortListMaps saat Sumbu X berubah
                            sortListMaps(
                              data: widget.data,
                              colName: xLabels[newIndex],
                              ascending: true,
                            );
                          });
                        },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // --- DROPDOWN UNTUK Y-AXIS ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sumbu Y (Nilai)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedYIndex,
                  isExpanded: true,
                  items: yLabels.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: yLabels.isEmpty
                      ? null
                      : (newIndex) {
                          setState(() {
                            _selectedYIndex = newIndex!;
                          });
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Hitung atribut setiap kali build dipanggil
      computeChartAtribute();

      // Ambil data yang sudah diproses
      final LineChartDataBundle chartData =
          _atributeChart['chartData'] as LineChartDataBundle;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildControls(),
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: LineChart(
                        // <- DIUBAH
                        LineChartData(
                          extraLinesData: _atributeChart['minY'] < 0
                              ? ExtraLinesData(
                                  horizontalLines: [
                                    HorizontalLine(y: 0, color: Colors.black),
                                  ],
                                )
                              : null,
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              // Tambahkan warna background agar tulisan terbaca jelas
                              getTooltipColor: (touchedSpot) =>
                                  Colors.lightBlueAccent,

                              getTooltipItems:
                                  (List<LineBarSpot> touchedBarSpots) {
                                    return touchedBarSpots.map((barSpot) {
                                      final index = barSpot.x.toInt();
                                      final List<String> daftarLabel =
                                          _atributeChart['chartData']
                                              .bottomTitles ??
                                          [];
                                      final String textLabel =
                                          (index >= 0 &&
                                              index < daftarLabel.length)
                                          ? daftarLabel[index]
                                          : '';

                                      // 3. Return tampilan text
                                      return LineTooltipItem(
                                        // Format Text: "Januari = 20"
                                        '$textLabel \n ${barSpot.y}',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      );
                                    }).toList();
                                  },
                            ),
                          ),

                          // --- Bagian bawah ini sama seperti kode Anda ---
                          minY: _atributeChart['minY'] as double,
                          maxY: _atributeChart['maxY'] as double,
                          lineBarsData: chartData.lineBarsData,

                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 50,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 30,
                              ),
                            ),
                          ),

                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      // print('Error building chart: $e');
      // print(s);
      return const SizedBox.shrink(
        child: Text("Gagal memuat chart"),
      ); // Tampilkan widget kosong jika error
    }
  }
}

class BarChartDataBundle {
  final List<BarChartGroupData> barGroups;
  final List<String> bottomTitles;

  BarChartDataBundle({required this.barGroups, required this.bottomTitles});
}

class LineChartDataBundle {
  final List<LineChartBarData> lineBarsData;
  final List<String> bottomTitles;

  LineChartDataBundle({required this.lineBarsData, required this.bottomTitles});
}

class ZoomableFullScreenImage extends StatelessWidget {
  final ImageProvider imageP;
  final String tag;

  const ZoomableFullScreenImage({
    super.key,
    required this.imageP,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam ala galeri
      body: Stack(
        children: [
          // 1. Gambar dengan kemampuan Zoom (PhotoView)
          Center(
            child: PhotoView(
              imageProvider: imageP,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.5, // Zoom maks 2.5x
              heroAttributes: PhotoViewHeroAttributes(tag: tag),
            ),
          ),

          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
