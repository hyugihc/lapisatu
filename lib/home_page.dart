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
            height: screenHeight * 0.4,
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
                const SizedBox(height: 20),
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'cari data disini...',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
        ),
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
              color: Colors.black.withOpacity(0.1),
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
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(imagePath, width: 50, height: 50),
          ),
          const SizedBox(height: 8),
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
    {'value': '4.30%', 'label': 'Tingkat pengangguran di kabupaten madiun 2025'},
    {'value': '3.14%', 'label': 'Tingkat inflasi tahunan (y-on-y) agustus 2025'},
    {'value': '7.20%', 'label': 'Persentase penduduk miskin maret 2025'},
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
                      color: Colors.black.withOpacity(0.1),
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
                color: _currentPage == index ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
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
    'lib/assets/WhatsApp Image 2025-05-09 at 11.22.09 AM.jpeg',
    'lib/assets/infografisbps2.jpg',
    'lib/assets/infografisbps1.jpg',
    'lib/assets/infografisbps2.jpg',
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
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Infografis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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