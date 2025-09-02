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

  Future<void> _sendToDB({
    required String nama,
    required String instansi,
    required String wa,
    required String email,
    required String req,
    required String? pathFileCloud,
  }) async {
    try {
      await firestore.collection('data-req').add({
        'nama': nama,
        'instansi': instansi,
        'phone_num': wa,
        'email': email,
        'data_req': req,
        'path_file': pathFileCloud,
      });
      print('Permintaan berhasil terkirim!');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickAndSavePdf(BuildContext konteks) async {
    // BUG
    // 1. MEMILIH FILE PDF DARI PERANGKAT
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      // Pengguna membatalkan pemilihan file
      setState(() {
        _status = false;
      });
      if (konteks.mounted) {
        _showSuccessSnackBar(konteks, 'Belum ada file yang dipilih!');
      }
      return;
    }
    // 2. MENYIAPKAN LOKASI PENYIMPANAN LOKAL
    // Ambil file yang dipilih (kita asumsikan hanya satu file)
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
      });
      print('File berhasil disimpan di: $_localFilePath');

      // DI SINI ANDA BISA MEMANGGIL FUNGSI UNGGAH KE CLOUD STORAGE
      // await _uploadToCloud(newFile);
    } catch (e) {
      setState(() {
        _status = false;
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
          Image.asset(
            'lib/assets/backgroundd.jpg',
            fit: BoxFit.cover,
            height: screenHeight * 0.4,
            width: double.infinity,
          ),

          //isi
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                //isi form
                Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
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

                      const SizedBox(height: 16),
                      const Text(
                        'Surat Permintaan Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              _pickAndSavePdf(context);
                            },
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upad file'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _sendToDB(
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
                                horizontal: 30,
                              ),
                            ),
                            child: const Text('Kirim'),
                          ),
                        ],
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
