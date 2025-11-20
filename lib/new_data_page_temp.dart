import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:typed_data';
// import 'package:excel/excel.dart';
// import 'package:file_saver/file_saver.dart';
// import 'package:intl/intl.dart';

// import 'package:lapis_satu/notif_try.dart';
// import 'package:lapis_satu/atoms/widgets_data.dart';
import 'package:lapis_satu/atoms/enum_var.dart';
import 'package:lapis_satu/atoms/const_var.dart';
import 'subcategory_data_page.dart';

class DataPage extends StatefulWidget {
  final Map<String, dynamic> mapData;
  final Set<String> displayedSC;
  const DataPage({super.key, required this.mapData, required this.displayedSC});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  // Daftar kategori (dari Enum)
  final List<String> _categoryOptions = [
    'Semua Kategori',
    ...Category.values.map((c) => c.name),
  ];

  String _selectedCategory = 'Semua Kategori';
  String _searchKeyword = '';

  // Map subkategori Anda
  Map<Category, List<String>> subCategory = AppVar.subCategory;
  late final Map<String, Category> _subcategoryToCategoryMap;

  @override
  void initState() {
    super.initState();
    // Buat map flat-nya saat init
    _subcategoryToCategoryMap = {};
    subCategory.forEach((categoryEnum, subcategoryList) {
      for (var subcatName in subcategoryList) {
        if (widget.displayedSC.contains(subcatName)) {
          _subcategoryToCategoryMap[subcatName] = categoryEnum;
        }
      }
    });
  }

  // Fungsi navigasi BARU: Pindah ke halaman daftar data
  void _showSubCategoryData(String subcategoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryDataPage(
          subcategoryName: subcategoryName,
          mapData: widget.mapData,
          // Kirim juga data subkategori jika perlu di halaman detail
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubcategories = _subcategoryToCategoryMap.keys.where((
      subcatName,
    ) {
      final categoryEnum = _subcategoryToCategoryMap[subcatName]!;
      final bool matchesCategory;
      if (_selectedCategory == 'Semua Kategori') {
        matchesCategory = true;
      } else {
        matchesCategory = (categoryEnum.name == _selectedCategory);
      }
      final bool matchesSearch = subcatName.toLowerCase().contains(
        _searchKeyword.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

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
                Container(color: Colors.black.withValues(alpha: .3)), // DIUBAH
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
                      const SizedBox(height: 16.0),

                      // TextField (tidak berubah)
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
                      const SizedBox(height: 8.0),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          hintText: 'Pilih Kategori',
                          prefixIcon: switch (_selectedCategory) {
                            'penduduk' => Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                'lib/assets/ic_sosial.png',
                                width: 10.0,
                                height: 10.0,
                              ),
                            ),
                            'ekonomi' => Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                'lib/assets/ic_ekonomi.png',
                                width: 5.0,
                                height: 10.0,
                              ),
                            ),
                            'pertanian' => Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                'lib/assets/ic_pertanian.png',
                                width: 10.0,
                                height: 10.0,
                              ),
                            ),
                            _ => Image.asset(
                              'lib/assets/logo bps.png',
                              width: 10.0,
                              height: 10.0,
                            ),
                          },
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ), // Dekorasi Dropdown Anda
                        items: _categoryOptions.map((String category) {
                          final String displayText;
                          if (category == 'penduduk') {
                            displayText = 'Demografi dan Sosial';
                          } else {
                            displayText =
                                category[0].toUpperCase() +
                                category.substring(1);
                          }
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(displayText),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
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
                    itemCount: filteredSubcategories.length,
                    itemBuilder: (context, index) {
                      return _buildSubCategoryItem(
                        title: filteredSubcategories[index],
                      );
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

  Widget _buildSubCategoryItem({required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05), // DIUBAH
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        // Panggil fungsi navigasi BARU
        onTap: () => _showSubCategoryData(title),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title, // Ini adalah nama subkategori
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              // Icon panah ke kanan, bukan 'north_east'
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black54,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
