import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lapis_satu/atoms/widgets_data.dart';
import 'dart:async';

import 'search_page.dart';
import 'new_data_page_temp.dart';
import 'detail_data_page.dart';
import 'menu_page.dart';
import 'permintaan_page.dart';
import 'konsultasi_page.dart';
import 'pengaduan_page.dart';
import 'magang_page.dart';
import 'infografis.dart';
import 'notif_try.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> mapData;
  final List<String> imgInfografis;
  final List<Map<String, String>> pubSample;
  final List<Map<String, String>> statsData;
  final Map<String, dynamic> othersVar;
  final String imgJadwal;
  const HomePage({
    super.key,
    required this.mapData,
    required this.imgInfografis,
    required this.pubSample,
    required this.statsData,
    required this.othersVar,
    required this.imgJadwal,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    if (index == 3) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const MenuPage();
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeContent(
        mapData: widget.mapData,
        imgInfografis: widget.imgInfografis,
        statsData: widget.statsData,
        jadwalImgPath: widget.imgJadwal,
      ),
      SearchPage(pubSample: widget.pubSample),
      DataPage(
        mapData: widget.mapData,
        displayedSC: widget.othersVar['displayedSC'],
      ),
      const MenuPage(),
    ];
    NotificationService().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Publikasi'),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'Lainnya',
          ),
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
class HomeContent extends StatefulWidget {
  final Map<String, dynamic> mapData;
  final List<String> imgInfografis;
  final List<Map<String, String>> statsData;
  final String jadwalImgPath;
  const HomeContent({
    super.key,
    required this.mapData,
    required this.imgInfografis,
    required this.statsData,
    required this.jadwalImgPath,
  });

  @override
  State<HomeContent> createState() => _HomeContent();
}

class _HomeContent extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
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
                                  Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SearchBar(mapData: widget.mapData),
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
                  child: StatsCard(statsData: widget.statsData),
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: MenuInfografis(imagePaths: widget.imgInfografis),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation:
                        2, // Opsional: tambah bayangan sedikit biar cantik
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZoomableFullScreenImage(
                                imageP: CachedNetworkImageProvider(
                                  widget.jadwalImgPath,
                                ),
                                tag: 'jadwal-pst',
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Hero(
                            tag: 'jadwa-pst',
                            child: CachedNetworkImage(
                              imageUrl: widget.jadwalImgPath,
                              placeholder: (context, url) => const SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(
                                    height: 200,
                                    child: Center(child: Icon(Icons.error)),
                                  ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Map<String, dynamic> mapData;
  const SearchBar({super.key, required this.mapData});

  @override
  Widget build(BuildContext context) {
    final List<String> dataTitles = mapData.keys.toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return dataTitles.where(
            (title) => title.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
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
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          );
        },
        onSelected: (String selection) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailDataPage(
                title: selection,
                // onBack: () => Navigator.pop(context),
                linkData: mapData[selection]['link'],
                mapData: mapData,
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
              'lib/assets/permintaan data.png',
              'Permintaan',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PermintaanPage()),
              ),
            ),
            _buildMenuItem(
              context,
              'lib/assets/consultant.png',
              'Konsultasi',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KonsultasiPage()),
              ),
            ),
            _buildMenuItem(
              context,
              'lib/assets/feedback.png',
              'Pengaduan',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PengaduanPage()),
              ),
            ),
            _buildMenuItem(
              context,
              'lib/assets/id-card.png',
              'Magang',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MagangPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String label,
    VoidCallback onTap,
  ) {
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
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ],
      ),
    );
  }
}

class StatsCard extends StatefulWidget {
  final List<Map<String, String>> statsData;
  const StatsCard({super.key, required this.statsData});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.statsData.length - 1) {
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
            itemCount: widget.statsData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final data = widget.statsData[index];
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
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
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
          children: List.generate(widget.statsData.length, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 2.0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Colors.blueAccent
                    : Colors.grey.withValues(alpha: .5),
              ),
            );
          }),
        ),
      ],
    );
  }
}
