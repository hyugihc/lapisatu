import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class PermintaanPage extends StatefulWidget {
  const PermintaanPage({super.key});

  @override
  State<PermintaanPage> createState() => _PermintaanPage();
}

class _PermintaanPage extends State<PermintaanPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _instansi = TextEditingController();
  final TextEditingController _noWa = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _dataReq = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _status = false;
  String? _localFilePath;
  String? _pickedFileName;

  Future<void> _sendToDB({
    required BuildContext context,
    required String nama,
    required String instansi,
    required String wa,
    required String email,
    required String req,
    required String? pathFileCloud,
  }) async {
    try {
      await firestore.collection('data-req').add({
        'name': nama,
        'instansi': instansi,
        'phone_num': wa,
        'email': email,
        'data_req': req,
        'path_file': pathFileCloud,
        'timestamp': FieldValue.serverTimestamp(),
        'title': 'Permintaan Data',
        'status': 'pending',
      });
      if (!context.mounted) return;
      _showStatusDialog(
        context,
        icon: Icons.check_circle_outline,
        color: Colors.green,
        message: 'Berhasil Dikirim!',
      );
      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      print('Error: $e');
      if (!context.mounted) return;

      _showStatusDialog(
        context,
        icon: Icons.highlight_off,
        color: Colors.red,
        message: 'Gagal Terkirim\nSilakan Coba Lagi',
      );
    }
  }

  void _showStatusDialog(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Otomatis tutup dialog setelah 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 80),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndSavePdf(BuildContext konteks) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      setState(() {
        _status = false;
      });
      if (konteks.mounted) {
        _showSuccessSnackBar(konteks, 'Belum ada file yang dipilih!');
      }
      return;
    }
    // 2. MENYIAPKAN LOKASI PENYIMPANAN LOKAL
    PlatformFile pickedFile = result.files.first;
    File sourceFile = File(pickedFile.path!);

    // Dapatkan direktori dokumen internal aplikasi
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String newPath = '${appDir.path}/${pickedFile.name}';

    // 3. MENYALIN FILE KE PENYIMPANAN LOKAL APLIKASI
    try {
      final File newFile = await sourceFile.copy(newPath);

      setState(() {
        _status = true;
        _localFilePath = newFile.path;
        _pickedFileName = pickedFile.name;
      });
      print('File berhasil disimpan di: $_localFilePath');

      // DI SINI ANDA BISA MEMANGGIL FUNGSI UNGGAH KE CLOUD STORAGE
      // await _uploadToCloud(newFile);
    } catch (e) {
      setState(() {
        _status = false;
        _pickedFileName = null;
      });
      print('Error: $e');
    }
    if (konteks.mounted) {
      _showSuccessSnackBar(konteks, 'Gagal Mengirim File');
    }
  }

  void _showSuccessSnackBar(BuildContext context, String teks) {
    if (_status) {
      final snackBar = SnackBar(
        content: const Text('Berhasil mengirim file!'),
        backgroundColor: Colors.green, // Optional: Ganti warna latar belakang
        behavior:
            SnackBarBehavior.floating, // Optional: Membuat SnackBar mengambang
        margin: const EdgeInsets.all(10), // Optional: Menambah margin
        duration: const Duration(seconds: 3), // Optional: Mengatur durasi
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(teks),
        backgroundColor: const Color.fromARGB(
          255,
          188,
          57,
          57,
        ), // Optional: Ganti warna latar belakang
        behavior:
            SnackBarBehavior.floating, // Optional: Membuat SnackBar mengambang
        margin: const EdgeInsets.all(10), // Optional: Menambah margin
        duration: const Duration(seconds: 3), // Optional: Mengatur durasi
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // --- BAGIAN BACKGROUND HEADER (TETAP SAMA) ---
          Image.asset(
            'lib/assets/backgroundd.jpg',
            fit: BoxFit.cover,
            height: screenHeight * 0.4,
            width: double.infinity,
          ),
          // --- KONTEN UTAMA DENGAN FORM ---
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN TEKS HEADER (TETAP SAMA) ---
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'PERMISI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 4.0, color: Colors.black54),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'PERMISI (Permintaan Data di Sini) adalah tempat untuk memfasilitasi Masyarakat dalam mengajukan permintaan data dengan ketentuan dan prosedur yang ada.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            shadows: [
                              Shadow(blurRadius: 2.0, color: Colors.black87),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // --- CONTAINER FORM (DENGAN PENAMBAHAN UI NAMA FILE) ---
                Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MEKANISME PERMINTAAN DATA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '1. Isikan permintaan data dalam docs yang sudah tertera dibawah',
                      ),
                      const Text(
                        '2. Permintaan data akan diproses selama 3-5 hari kerja',
                      ),
                      const Text(
                        '3. feedback akan dikirimkan BPS Kabupaten Madiun melalui no wa aktif atau email yang telah terdaftar',
                      ),
                      const SizedBox(height: 24),

                      _buildTextField(label: 'Nama Lengkap', varText: _name),
                      _buildTextField(
                        label: 'Nama Instansi',
                        varText: _instansi,
                      ),
                      _buildTextField(label: 'No wa aktif', varText: _noWa),
                      _buildTextField(label: 'Email aktif', varText: _email),
                      _buildTextField(
                        label: 'Data yang diminta',
                        varText: _dataReq,
                      ),

                      const SizedBox(height: 24),

                      // --- BAGIAN UPLOAD FILE YANG DIPERBARUI ---
                      const Text(
                        'Surat Permintaan Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          _pickAndSavePdf(context);
                        },
                        icon: const Icon(Icons.upload_file),
                        // Teks tombol berubah secara dinamis
                        label: Text(
                          _pickedFileName == null
                              ? 'Pilih File PDF'
                              : 'Ganti File',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue[800],
                          side: BorderSide(color: Colors.blue[800]!),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Widget untuk menampilkan nama file yang dipilih
                      if (_pickedFileName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.attach_file,
                                color: Colors.black54,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _pickedFileName!,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _sendToDB(
                              context: context,
                              nama: _name.text,
                              instansi: _instansi.text,
                              wa: _noWa.text,
                              email: _email.text,
                              req: _dataReq.text,
                              pathFileCloud: _localFilePath,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Kirim Permintaan'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController varText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          TextField(
            controller: varText,
            decoration: InputDecoration(
              hintText: 'Jawaban anda',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
