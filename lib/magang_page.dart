import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MagangPage extends StatefulWidget {
  const MagangPage({super.key});

  @override
  State<MagangPage> createState() => _MagangPage();
}

class _MagangPage extends State<MagangPage> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _noWa = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _req = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _saveMagang({
    required BuildContext context,
    required String name,
    required String nik,
    required String noWa,
    required String email,
    required String req,
  }) async {
    try {
      await firestore.collection('intern-req').add({
        'name': name,
        'identity_num': nik,
        'phone_num': noWa,
        'email': email,
        'keperluan': req,
        'timestamp': FieldValue.serverTimestamp(),
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
      print('Error $e');
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
                //header
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
                          'MAGANG',
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
                          'Badan Pusat Statistik (BPS) Kabupaten Madiun membuka peluang magang bagi pelajar untuk memenuhi tugas praktik kerja dari kampus atau sekolah.',
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
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MEKANISME PENGAJUAN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMechanismItem(
                        number: '1.',
                        text:
                            'Syarat pengajuan magang adalah Mahasiswa/siswa yang berstatus masih AKTIF belajar di kampus atau sekolah.',
                      ),
                      const SizedBox(height: 8),
                      _buildMechanismItem(
                        number: '2.',
                        text:
                            'Mahasiswa/siswa harus mengirimkan surat pengantar resmi dan proposal dari kampus atau sekolah yang ditujukkan kepada Kepala BPS Kabupaten Madiun. Surat dan proposal dapat dikirimkan via Kantor POS atau datang langsung ke Kantor BPS Kabupaten Madiun. Jl Marsma TNI Anumerta R.Iswahjudi No.30, Jiwan Utara, Kec. Jiwan Kabupaten Madiun, Jawa Timur, 63164',
                      ),
                      const SizedBox(height: 8),
                      _buildMechanismItem(
                        number: '3.',
                        text:
                            'Setelah surat masuk, BPS Kabupaten Madiun akan memproses dengan memperhatikan ketersediaan kuota magang.',
                      ),
                      const SizedBox(height: 8),
                      _buildMechanismItem(
                        number: '4.',
                        text:
                            'Informasi penerimaan akan disampaikan melalui surat balasan resmi yang dikirimkan ke alamat kampus atau sekolah.',
                      ),
                      const SizedBox(height: 24),

                      //isi form
                      const Divider(),
                      const SizedBox(height: 24),
                      const Text(
                        'FORMULIR PENGAJUAN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(label: 'Nama Lengkap', varText: _nama),
                      _buildTextField(
                        label: 'NIK/Nomor Kartu Pelajar',
                        varText: _nik,
                      ),
                      _buildTextField(label: 'No WA Aktif', varText: _noWa),
                      _buildTextField(label: 'Email Aktif', varText: _email),
                      _buildTextField(label: 'Keperluan', varText: _req),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _saveMagang(
                                context: context,
                                name: _nama.text,
                                nik: _nik.text,
                                noWa: _noWa.text,
                                email: _email.text,
                                req: _req.text,
                              );
                              _nama.clear();
                              _nik.clear();
                              _noWa.clear();
                              _email.clear();
                              _req.clear();
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

  Widget _buildMechanismItem({required String number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
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
