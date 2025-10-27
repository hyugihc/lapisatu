import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'modern_infografis.dart';

class MenuInfografis extends StatelessWidget {
  final List<String> imagePaths;
  const MenuInfografis({super.key, required this.imagePaths});

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModernInfografisListView(),
                    ),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CachedNetworkImage(
                  imageUrl: imagePaths[index],
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class InfografisLengkap extends StatefulWidget {
//   const InfografisLengkap({super.key});

//   @override
//   State<InfografisLengkap> createState() => _InfografisLengkapState();
// }

// class _InfografisLengkapState extends State<InfografisLengkap> {
//   // Fungsi untuk menampilkan dialog (diubah menggunakan Image.network)
//   void _showImageDialog(BuildContext context, Map<String, String> info) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           contentPadding: EdgeInsets.zero,
//           insetPadding: const EdgeInsets.symmetric(
//             horizontal: 10,
//             vertical: 24,
//           ),
//           content: Container(
//             height: MediaQuery.of(context).size.height * 0.7,
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   info['title']!,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Expanded(
//                   flex: 4,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: CachedNetworkImage(
//                       imageUrl: info['image']!,
//                       placeholder: (context, url) =>
//                           const Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                       fit: BoxFit.contain,
//                       width: double.infinity,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   flex: 1,
//                   child: SingleChildScrollView(
//                     child: Text(
//                       info['description']!,
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Fungsi untuk mengambil data dari Firestore
//   Future<List<Map<String, String>>> fetchInfografisFromFirestore() async {
//     try {
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('infografis')
//           .orderBy('time_upload', descending: true)
//           .limit(10)
//           .get();

//       if (snapshot.docs.isEmpty) {
//         return [];
//       }

//       final List<Map<String, String>> infografisList = snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return {
//           'title': data['title']?.toString() ?? 'Tanpa Judul',
//           'image': data['image']?.toString() ?? '',
//           'description':
//               data['description']?.toString() ?? 'Tidak ada deskripsi.',
//         };
//       }).toList();

//       return infografisList;
//     } catch (e) {
//       print("Error saat mengambil data infografis: $e");
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Desain AppBar Anda tetap sama
//         automaticallyImplyLeading: false,
//         flexibleSpace: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.asset('lib/assets/backgroundd.jpg', fit: BoxFit.cover),
//             Container(
//               color: Colors.black.withValues(alpha: .3),
//             ), // Menggunakan withOpacity
//           ],
//         ),
//         title: const Text(
//           'Semua Infografis',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),

//       body: FutureBuilder<List<Map<String, String>>>(
//         future: fetchInfografisFromFirestore(), // Panggil fungsi fetch di sini
//         builder: (context, snapshot) {
//           // Saat data masih dimuat, tampilkan loading indicator
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Jika terjadi error
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Gagal memuat data. Silakan coba lagi.'),
//             );
//           }

//           // Jika tidak ada data
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Tidak ada infografis tersedia.'));
//           }

//           // Jika data berhasil dimuat, bangun MasonryGridView
//           final infografisList = snapshot.data!;

//           return MasonryGridView.count(
//             padding: const EdgeInsets.all(16.0),
//             crossAxisCount: 2,
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//             itemCount: infografisList.length,
//             itemBuilder: (context, index) {
//               final info = infografisList[index];

//               return GestureDetector(
//                 onTap: () => _showImageDialog(context, info),
//                 child: Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   clipBehavior: Clip.antiAlias,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: info['image']!,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) =>
//                             const Center(child: CircularProgressIndicator()),
//                         errorWidget: (context, error, stackTrace) {
//                           return Container(
//                             height: 100, // Beri tinggi agar terlihat
//                             color: Colors.grey[200],
//                             child: const Icon(
//                               Icons.broken_image,
//                               color: Colors.grey,
//                             ),
//                           );
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Text(
//                           info['title']!,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
