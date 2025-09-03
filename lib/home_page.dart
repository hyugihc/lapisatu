import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';

import 'search_page.dart';
import 'data_page.dart';
import 'menu_page.dart';
import 'permintaan_page.dart';
import 'konsultasi_page.dart';
import 'pengaduan_page.dart';
import 'magang_page.dart';

//frame
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // listbutton
  static final List<Widget> _pages = <Widget>[
    const HomeContent(), 
    const SearchPage(),  
    const DataPage(),
    const MenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// homepage
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.3,
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  'lib/assets/backgroundd.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                            const Text(
                              'BPS Kabupaten Madiun',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 4.0, color: Colors.black54),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const SearchBar(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // frame konten
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              children: [
                const MenuBar(),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: const StatsCard(),
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: const MenuInfografis(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//widget bagian homepage
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return DataPage.dataTitles.where((title) =>
            title.toLowerCase().contains(textEditingValue.text.toLowerCase())
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'cari data disini...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
            ),
          );
        },
        onSelected: (String selection) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailDataPage(
                title: selection,
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMenuItem(
              context,
              'lib/assets/mobile-analysis.png',
              'Permintaan',
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PermintaanPage())),
            ),
            _buildMenuItem(
              context,
              'lib/assets/consultant.png',
              'Konsultasi',
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KonsultasiPage())),
            ),
            _buildMenuItem(
              context,
              'lib/assets/feedback.png',
              'Pengaduan',
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PengaduanPage())),
            ),
            _buildMenuItem(
              context,
              'lib/assets/id-card.png',
              'Magang',
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MagangPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String imagePath, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(imagePath, width: 50, height: 50),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatefulWidget {
  const StatsCard({super.key});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  final List<Map<String, String>> statsData = [
    {'value': '4.30%', 'label': 'Tingkat pengangguran di Kabupaten Madiun 2025'},
    {'value': '3.14%', 'label': 'Tingkat inflasi tahunan (y-on-y) Agustus 2025'},
    {'value': '7.20%', 'label': 'Persentase Penduduk miskin Maret 2025'},
    {'value': '69.69%', 'label': 'Tingkat Polusi Udara di Kabupaten Madiun pada Agustus 2025'}
  ];

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < statsData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            itemCount: statsData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final data = statsData[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      data['value']!,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        data['label']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(statsData.length, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blueAccent : Colors.grey.withValues(alpha: 0.5),
              ),
            );
          }),
        ),
      ],
    );
  }
}
  
class MenuInfografis extends StatelessWidget {
  const MenuInfografis({super.key});

  final List<String> imagePaths = const [
    'lib/assets/infografisbps1.jpg',
    'lib/assets/infografisbps2.jpg',
    'lib/assets/upahburuh.jpg',
    'lib/assets/pertumbuhanekonomi.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Infografis',
                style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfografisLengkap(),
                    ),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(imagePaths[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}



class InfografisLengkap extends StatelessWidget {
  const InfografisLengkap({super.key});

  static final List<Map<String, String>> infografisList = [
    {
      'title': 'Infografis Penduduk 2025',
      'image': 'lib/assets/infografisbps1.jpg',
      'description': 'Ini adalah deskripsi detail mengenai infografis kependudukan tahun 2025 di Kabupaten Madiun hore hore horas!!!',
    },
    {
      'title': 'Infografis Ekonomi Kabupaten',
      'image': 'lib/assets/infografisbps2.jpg',
      'description': 'Rangkuman data ekonomi kabupaten, mencakup PDRB, inflasi, dan sektor-sektor penggerak utama...',
    },
    {
      'title': 'Rata-Rata Upah Buruh',
      'image': 'lib/assets/upahburuh.jpg',
      'description': 'Gambaran umum mengenai rata-rata upah buruh per sektor...',
    },
    {
      'title': 'Pertumbuhan Ekonomi',
      'image': 'lib/assets/pertumbuhanekonomi.jpg',
      'description': 'Grafik yang menunjukkan laju pertumbuhan ekonomi Kabupaten Madiun dari tahun ke tahun.',
    },
  ];

  void _showImageDialog(BuildContext context, Map<String, String> info) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
        content: 
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    info['title']!,
                    textAlign: TextAlign.center, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        info['image']!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child:SingleChildScrollView(
                      child: Text(
                        info['description']!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Semua Infografis',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MasonryGridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: infografisList.length,
        itemBuilder: (context, index) {
          final info = infografisList[index];
          
          return GestureDetector(
            onTap: () => _showImageDialog(context, info),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(info['image']!),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      info['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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