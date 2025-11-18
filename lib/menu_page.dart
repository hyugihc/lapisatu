import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  final List<Map<String, dynamic>> menuData = const [
    {
      'title': 'Informasi Umum BPS',
      'icon': Icons.info_outline,
      'type': 'link',
      'content': 'https://ppid.bps.go.id/app/konten/3519/Profil-BPS.html',
    },
    {
      'title': 'Rating Aplikasi',
      'icon': Icons.star_rate_outlined,
      'type': 'dialog',
    },
  ];

  void _showRatingDialog(BuildContext context) {
    double ratingValue = 0;
    final feedbackController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Beri Penilaian & Saran'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nama (opsional)
                StatefulBuilder(
                  builder: (context, setState) {
                    return RatingBar.builder(
                      initialRating: ratingValue,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          ratingValue = rating;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Rating bintang
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Nama (opsional)',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                // Saran
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Tulis saran atau masukan Anda di sini...',
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('NANTI SAJA'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('KIRIM'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('reviews-user')
                      .add({
                        'nama': nameController.text.trim(),
                        'rating': ratingValue,
                        'saran': feedbackController.text.trim(),
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Terima kasih atas penilaian dan saran Anda',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal Mengirim: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

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
              const Text(
                'Lainnya',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
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
              return _buildMenuListTile(context: context, itemData: item);
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
        switch (itemData['type']) {
          case 'link':
            _launchURL(itemData['content'] as String);
            break;
          case 'dialog':
            Navigator.pop(context);
            _showRatingDialog(context);
            break;
          default: // 'page' atau 'image'
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetailPage(itemData: itemData),
              ),
            );
        }
      },
    );
  }
}

class MenuDetailPage extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const MenuDetailPage({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    final String title = itemData['title'];
    final String contentType = itemData['type'];
    final dynamic content = itemData['content'];

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/backgroundd.jpg',
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
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
                          ),
                        ],
                      ),
                      child: contentType == 'image'
                          ? Column(
                              children: (content as List<String>).map((
                                imagePath,
                              ) {
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
