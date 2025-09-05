import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  final List<Map<String, dynamic>> menuData = const [
    {
      'title': 'Informasi Umum BPS',
      'icon': Icons.info_outline,
      'type': 'text',
      'content': 'Badan Pusat Statistik adalah Lembaga Pemerintah Non Kementerian yang bertanggung jawab langsung kepada Presiden ah ah ah',
    },
    {
      'title': 'Visi dan Misi BPS',
      'icon': Icons.visibility_outlined,
      'type': 'text',
      'content': 'Ini adalah deskripsi untuk Visi dan Misi BPS ah ah.',
    },
    {
      'title': 'Struktur Organisasi BPS',
      'icon': Icons.account_tree_outlined,
      'type': 'image',
      'content': [
        'lib/assets/strukturbps1.png',
        'lib/assets/strukturbps2.png',
      ]
    },
    {
      'title': 'Tugas, Fungsi, dan Kewenangan BPS',
      'icon': Icons.assignment_outlined,
      'type': 'text',
      'content': 'Ini adalah deskripsi untuk Tugas, Fungsi, dan Kewenangan BPS ah ah ah',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lainnya', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuData.length,
            itemBuilder: (context, index) {
              final item = menuData[index];
              return _buildMenuListTile(
                context: context,
                itemData: item,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListTile({
    required BuildContext context,
    required Map<String, dynamic> itemData,
  }) {
    return ListTile(
      leading: Icon(itemData['icon'] as IconData, color: Colors.grey[600]),
      title: Text(itemData['title'] as String),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailPage(
              itemData: itemData,
            ),
          ),
        );
      },
    );
  }
}

class MenuDetailPage extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const MenuDetailPage({
    super.key,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context) {
    final String title = itemData['title'];
    final String contentType = itemData['type'];
    final dynamic content = itemData['content'];

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/backgroundd.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: contentType == 'image'
                          ? Column(
                              children: (content as List<String>).map((imagePath) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(imagePath),
                                  ),
                                );
                              }).toList(),
                            )
                          : Text(
                              content as String,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}