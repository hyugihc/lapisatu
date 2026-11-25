import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // 1. Tambahkan Import ini
import 'package:file_picker/file_picker.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';
import 'send_notif.dart'; // Pastikan file ini ada

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
  bool _isLoading = false;
  Uint8List? _pickedFileBytes;
  String? _pickedFileName;

  final _formKey = GlobalKey<FormState>();

  // Fungsi dimodifikasi untuk handle Upload Storage
  Future<void> _sendToDB({
    required BuildContext context,
    required Uint8List? fileBytes,
    required String? fileName,
  }) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String? downloadUrl;
      final String nama = _name.text;
      final String instansi = _instansi.text;
      final String wa = _noWa.text;
      final String email = _email.text;
      final String req = _dataReq.text;
      try {
        if (fileBytes != null && fileName != null) {
          String uniqueFileName =
              '${nama}_${DateTime.now().millisecondsSinceEpoch}_$fileName';

          Reference storageRef = FirebaseStorage.instance.ref().child(
            'layanan/permintaan data/$uniqueFileName',
          );

          TaskSnapshot snapshot = await storageRef.putData(
            fileBytes,
            SettableMetadata(contentType: 'application/pdf'),
          );
          downloadUrl = await snapshot.ref.getDownloadURL();
        }
        await firestore.collection('data-req').add({
          'name': nama,
          'instansi': instansi,
          'phone_num': wa,
          'email': email,
          'data_req': req,
          'path_file':
              downloadUrl, // Simpan URL Firebase Storage, BUKAN path lokal
          'timestamp': FieldValue.serverTimestamp(),
          'title': 'Permintaan Data',
          'status': 'pending',
        });

        sendNotificationV1(
          title: 'Permintaan Data Baru',
          body: 'Permintaan data dari $nama telah masuk.',
        );

        if (!context.mounted) return;

        setState(() {
          _isLoading = false;
        });

        _showStatusDialog(
          context,
          icon: Icons.check_circle_outline,
          color: Colors.green,
          message: 'Berhasil Dikirim!',
        );

        await Future.delayed(const Duration(seconds: 2));
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      } catch (e) {
        // print('Error saat mengirim: $e');

        setState(() {
          _isLoading = false;
        });

        if (!context.mounted) return;
        _showStatusDialog(
          context,
          icon: Icons.highlight_off,
          color: Colors.red,
          message: 'Gagal Terkirim\n${e.toString()}', // Tampilkan pesan error
        );
      }
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
        // Otomatis tutup dialog setelah 2 detik (kecuali error mungkin butuh dibaca user)
        if (color == Colors.green) {
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }

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
      withData: true,
    );

    if (result == null || result.files.first.bytes == null) {
      setState(() {
        _status = false;
      });
      if (konteks.mounted) {
        _showSuccessSnackBar(konteks, 'Belum ada file yang dipilih!');
      }
      return;
    }

    PlatformFile pickedFile = result.files.first;
    setState(() {
      _status = true;
      _pickedFileBytes = pickedFile.bytes;
      _pickedFileName = pickedFile.name;
    });
  }

  void _showSuccessSnackBar(BuildContext context, String teks) {
    final snackBar = SnackBar(
      content: Text(teks),
      backgroundColor: _status
          ? Colors.green
          : const Color.fromARGB(255, 188, 57, 57),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                  child: Form(
                    key: _formKey,
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

                        generateInputField(
                          label: "Nama Lengkap",
                          varText: _name,
                          validator: ValidatorInput.defaultRequired,
                        ),
                        generateInputField(
                          label: "Nama Instansi",
                          varText: _instansi,
                          validator: ValidatorInput.defaultRequired,
                        ),
                        generateInputField(
                          label: "No. WA Aktif",
                          varText: _noWa,
                          validator: ValidatorInput.validatePhoneNumber,
                        ),
                        generateInputField(
                          label: "Email Aktif",
                          varText: _email,
                          validator: ValidatorInput.validateEmail,
                        ),
                        generateInputField(
                          label: "Data yang diminta",
                          varText: _dataReq,
                          validator: ValidatorInput.defaultRequired,
                        ),

                        // _buildTextField(label: 'Nama Lengkap', varText: _name),
                        // _buildTextField(
                        //   label: 'Nama Instansi',
                        //   varText: _instansi,
                        // ),
                        // _buildTextField(label: 'No wa aktif', varText: _noWa),
                        // _buildTextField(label: 'Email aktif', varText: _email),
                        // _buildTextField(
                        //   label: 'Data yang diminta',
                        //   varText: _dataReq,
                        // ),
                        const SizedBox(height: 24),

                        const Text(
                          'Surat Permintaan Data',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _pickAndSavePdf(context),
                          icon: const Icon(Icons.upload_file),
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
                            // Nonaktifkan tombol jika sedang loading
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _sendToDB(
                                      context: context,
                                      fileBytes: _pickedFileBytes,
                                      fileName: _pickedFileName,
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
                              // Berikan visual disabled jika loading
                              disabledBackgroundColor: Colors.blue[800]
                                  ?.withValues(alpha: .6),
                            ),
                            // Tampilkan Loading Indicator jika sedang proses
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text('Kirim Permintaan'),
                          ),
                        ),
                      ],
                    ),
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

  // Widget _buildTextField({
  //   required String label,
  //   required TextEditingController varText,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 8.0),
  //         TextField(
  //           controller: varText,
  //           decoration: InputDecoration(
  //             hintText: 'Jawaban anda',
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             contentPadding: const EdgeInsets.symmetric(
  //               horizontal: 12.0,
  //               vertical: 10.0,
  //             ),
  //             isDense: true,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
