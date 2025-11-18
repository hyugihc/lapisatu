import 'package:flutter/material.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';
import 'detail_data_page.dart';

class SubCategoryDataPage extends StatefulWidget {
  final String subcategoryName;
  final Map<String, dynamic> mapData;

  const SubCategoryDataPage({
    super.key,
    required this.subcategoryName,
    required this.mapData,
  });

  @override
  State<SubCategoryDataPage> createState() => _SubCategoryDataPageState();
}

class _SubCategoryDataPageState extends State<SubCategoryDataPage> {
  String _searchKeyword = ''; // Search bar lokal untuk halaman ini
  String? _selectedTitle;
  String? _link;

  // Ini adalah fungsi _showDetail ASLI dari DataPage
  // Pindah ke sini
  void _showDetail(String title, BuildContext context) {
    setState(() {
      _selectedTitle = title;
      _link = widget.mapData[title]['link'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailDataPage(
            title: _selectedTitle as String,
            linkData: _link,
            mapData: widget.mapData,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- LOGIKA FILTER ASLI (dengan modifikasi) ---
    final filteredTitles = widget.mapData.keys.toList().where((title) {
      final data = widget.mapData[title];

      // 1. Filter berdasarkan Subkategori (DARI ASUMSI KITA)
      final String nameSC = getNameSC(
        subCatIdx: data['subcategory'],
        category: id2Cat(catIdx: data['category']),
      )!;
      // print(nameSC);
      final bool matchesSubCategory = (nameSC == widget.subcategoryName);

      // 2. Filter berdasarkan keyword pencarian LOKAL
      final bool matchesSearch = title.toLowerCase().contains(
        _searchKeyword.toLowerCase(),
      );

      // 3. Filter 'root' (seperti sebelumnya)
      // final bool isDisplayed = (data['root'] ?? true);

      return matchesSubCategory && matchesSearch;
    }).toList();
    // --- BATAS LOGIKA FILTER ---

    return Scaffold(
      backgroundColor: Colors.grey[200],
      // AppBar sederhana untuk halaman ini
      appBar: AppBar(
        title: Text(widget.subcategoryName),
        // Anda bisa tambahkan background kustom di sini jika mau
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Lokal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari di dalam ${widget.subcategoryName}...',
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
            ),

            // ListView (ini adalah ListView ASLI Anda)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTitles.length,
                itemBuilder: (context, index) {
                  // Panggil _buildDataItem ASLI
                  return _buildDataItem(title: filteredTitles[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Ini adalah _buildDataItem ASLI dari DataPage
  // Pindah ke sini
  Widget _buildDataItem({required String title}) {
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
        onTap: () => _showDetail(title, context), // Panggil _showDetail LOKAL
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
              const Icon(Icons.north_east, color: Colors.black54), // Ikon asli
            ],
          ),
        ),
      ),
    );
  }
}
