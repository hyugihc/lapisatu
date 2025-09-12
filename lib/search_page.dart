import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, String>> pubSample;
  const SearchPage({super.key, required this.pubSample});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Map<String, String>> _allPublications;
  List<Map<String, String>> _publicatsionFound = [];

  @override
  void initState() {
    _allPublications = widget.pubSample;
    _publicatsionFound = _allPublications;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPublications;
    } else {
      results = _allPublications
          .where(
            (pub) => pub['title']!.toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    }
    setState(() {
      _publicatsionFound = results;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cari Publikasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Cari Publikasi disini',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            Expanded(
              child: _publicatsionFound.isNotEmpty
                  ? ListView.builder(
                      itemCount: _publicatsionFound.length,
                      itemBuilder: (context, index) {
                        return _buildDataItem(
                          context: context,
                          itemData: _publicatsionFound[index],
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Tidak ada publikasi ditemukan.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem({
    required BuildContext context,
    required Map<String, String> itemData,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSearchPage(
                publicationData: itemData,
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
          print('${itemData['title']} diklik!');
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: itemData['image']!,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          itemData['date']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      itemData['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      itemData['description']!,
                      style: TextStyle(color: Colors.grey[700]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailSearchPage extends StatelessWidget {
  final Map<String, String> publicationData;
  final VoidCallback onBack;

  const DetailSearchPage({
    super.key,
    required this.publicationData,
    required this.onBack,
  });

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
          'Detail Publikasi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                publicationData['title']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: publicationData['image']!,
                    height: 300,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // _launchURL(pathUrl: publicationData['link'] as String);
                    final Uri url = Uri.parse(
                      publicationData['link'] as String,
                    );
                    launchUrl(url, mode: LaunchMode.externalApplication);
                    // print(publicationData['link'] as String);
                  },
                  icon: const Icon(Icons.web),
                  label: const Text('Kunjungi Publikasi'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetadataRow(
                    'Nomor Katalog',
                    publicationData['NoKatal']!,
                  ),
                  _buildMetadataRow(
                    'Nomor Publikasi',
                    publicationData['NoPub']!,
                  ),
                  _buildMetadataRow('ISSN/ISBN', publicationData['ISSN/ISBN']!),
                  _buildMetadataRow(
                    'Frekuensi Terbit',
                    publicationData['terbit']!,
                  ),
                  _buildMetadataRow('Tanggal Rilis', publicationData['date']!),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Abstraksi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                publicationData['description']!,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.grey[800], height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(title, style: TextStyle(color: Colors.grey[700])),
          ),
          const SizedBox(width: 8),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
