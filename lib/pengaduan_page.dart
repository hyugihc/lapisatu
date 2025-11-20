import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';
import 'send_notif.dart';

class PengaduanPage extends StatefulWidget {
  const PengaduanPage({super.key});

  @override
  State<PengaduanPage> createState() => _PengaduanPage();
}

class _PengaduanPage extends State<PengaduanPage> {
  final TextEditingController _type = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _noWa = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pengaduan = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _savePengaduan({required BuildContext context}) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final firestore = FirebaseFirestore.instance;
      try {
        await firestore.collection('complain-req').add({
          'complain_type': _type.text,
          'name': _nama.text,
          'phone_num': _noWa.text,
          'email': _email.text,
          'complain_text': _pengaduan.text,
          'timestamp': FieldValue.serverTimestamp(),
          'title': 'Pengaduan',
          'status': 'pending',
        });

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

        sendNotificationV1(
          title: 'Notifikasi Pengaduan',
          body: 'Pengaduan dari ${_nama.text} telah masuk',
        );
        if (!context.mounted) return;

        Navigator.of(context).pop();
      } catch (e) {
        // print(e);

        if (!context.mounted) return;

        _showStatusDialog(
          context,
          icon: Icons.highlight_off,
          color: Colors.red,
          message: 'Gagal Terkirim\nSilakan Coba Lagi',
        );
        _isLoading = false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
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
                          'PENGADUAN',
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
                          'Pengaduan dilakukan dengan mengisi form SAPA (Sistem Aspirasi dan Pengaduan Pelayanan) BPS Kabupaten Madiun',
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MEKANISME PENGADUAN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '1. Isikan pengaduan dalam docs yang telah disediakan dibawah ini',
                        ),
                        const Text(
                          '2. Petugas menerima pengaduan serta memproses pengaduan bersama tim',
                        ),
                        const Text(
                          '3. feedback akan dikirimkan BPS Kabupaten Madiun melalui no wa aktif atau email yang telah terdaftar',
                        ),
                        const SizedBox(height: 24),

                        generateInputField(
                          label: 'Jenis Pengaduan',
                          varText: _type,
                          validator: ValidatorInput.defaultRequired,
                        ),
                        generateInputField(
                          label: 'Nama Lengkap',
                          varText: _nama,
                          validator: ValidatorInput.defaultRequired,
                        ),
                        generateInputField(
                          label: 'No. WA Aktif',
                          varText: _noWa,
                          validator: ValidatorInput.validatePhoneNumber,
                        ),
                        generateInputField(
                          label: 'Email Aktif',
                          varText: _email,
                          validator: ValidatorInput.validateEmail,
                        ),
                        generateInputField(
                          label: 'Detail Pengaduan',
                          varText: _pengaduan,
                          validator: ValidatorInput.defaultRequired,
                          maxLine: 5,
                        ),
                        // _buildTextField(label: 'Jenis Pengaduan', varText: _type),
                        // _buildTextField(label: 'Nama Lengkap', varText: _nama),
                        // _buildTextField(label: 'No wa aktif', varText: _noWa),
                        // _buildTextField(label: 'Email aktif', varText: _email)
                        // _buildTextField(
                        //   label: 'Pengaduan',
                        //   maxLine: 5,
                        //   varText: _pengaduan,
                        // ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _savePengaduan(context: context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                              ),
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
                          ],
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
  //   int maxLine = 1,
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
  //           maxLines: maxLine,
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
