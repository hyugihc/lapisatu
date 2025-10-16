import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lapis_satu/atoms/enum_var.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'dart:math';

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
                ? 50
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
        if (value is int) return 'TEMPEK';
        return DateFormat('MMMM yyyy', 'id_ID').format(value);
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
  final Map<String, dynamic> atribut;
  const DesignedBarChart({
    super.key,
    required this.data,
    required this.atribut,
  });

  @override
  State<DesignedBarChart> createState() => _DesignedBarChart();
}

class _DesignedBarChart extends State<DesignedBarChart> {
  final Map<String, dynamic> _atributeChart = {};
  late final Map<String, List> _recomColumn;

  @override
  void initState() {
    _recomColumn = _findColumnFitName();
    super.initState();
  }

  Map<String, List> _findColumnFitName() {
    List<String> xLabel = [];
    List<String> yCol = [];

    for (var col in (widget.atribut['column'])) {
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
    int idkX = 0,
    int idkY = 0,
  }) {
    if (data.isEmpty) {
      return BarChartDataBundle(barGroups: [], bottomTitles: []);
    }

    List<BarChartGroupData> barGroups = [];
    List<String> bottomTitles = [];
    String xLabel = _recomColumn['xlabel']![idkX];
    String yLabel = _recomColumn['ylabel']![idkY];

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

    chartData = transformDataToBarData(data: widget.data);

    yValues = chartData.barGroups
        .map((group) => group.barRods.first.toY)
        .toList();
    minYValue = yValues.reduce(min);
    maxYValue = yValues.reduce(max);

    if (minYValue == maxYValue) {
      paddingY = minYValue * 0.5;
    } else {
      paddingY = (maxYValue - minYValue) * 0.5;
    }

    if ((minYValue - paddingY).floorToDouble() < 0) {
      minYChart = 0;
    } else {
      minYChart = (minYValue - paddingY).floorToDouble();
    }

    maxYChart = (maxYValue + paddingY).ceilToDouble();

    _atributeChart['chartData'] = chartData;
    _atributeChart['minY'] = minYChart;
    _atributeChart['maxY'] = maxYChart;
  }

  @override
  Widget build(BuildContext context) {
    computeChartAtribute();
    return BarChart(
      BarChartData(
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
                final String title =
                    _atributeChart['chartData'].bottomTitles[value.toInt()];
                return SideTitleWidget(meta: meta, child: Text(title));
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}

class BarChartDataBundle {
  final List<BarChartGroupData> barGroups;
  final List<String> bottomTitles;

  BarChartDataBundle({required this.barGroups, required this.bottomTitles});
}
