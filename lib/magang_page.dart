import 'package:flutter/material.dart';

class MagangPage extends StatelessWidget {
  const MagangPage({super.key});

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
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'MAGANG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 4.0, color: Colors.black54)],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Badan Pusat Statistik (BPS) Kabupaten Madiun membuka peluang magang bagi pelajar untuk memenuhi tugas praktik kerja dari kampus atau sekolah.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            shadows: [Shadow(blurRadius: 2.0, color: Colors.black87)],
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
                        color: Colors.black.withOpacity(0.1),
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
                        text: 'Syarat pengajuan magang adalah Mahasiswa/siswa yang berstatus masih AKTIF belajar di kampus atau sekolah.',
                      ),
                      const SizedBox(height: 8),
                      _buildMechanismItem(
                        number: '2.',
                        text: 'Mahasiswa/siswa harus mengirimkan surat pengantar resmi dan proposal dari kampus atau sekolah yang ditujukkan kepada Kepala BPS Kabupaten Madiun. Surat dan proposal dapat dikirimkan via Kantor POS atau datang langsung ke Kantor BPS Kabupaten Madiun. Jl Marsma TNI Anumerta R.Iswahjudi No.30, Jiwan Utara, Kec. Jiwan Kabupaten Madiun, Jawa Timur, 63164',
                      ),
                      const SizedBox(height: 8),
                      _buildMechanismItem(
                        number: '3.',
                        text: 'Setelah surat masuk, BPS Kabupaten Madiun akan memproses dengan memperhatikan ketersediaan kuota magang.',
                      ),
                      const SizedBox(height: 8),
                      _buildMechanismItem(
                        number: '4.',
                        text: 'Informasi penerimaan akan disampaikan melalui surat balasan resmi yang dikirimkan ke alamat kampus atau sekolah.',
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
                      _buildTextField(label: 'Nama Lengkap'),
                      _buildTextField(label: 'NIK/Nomor Kartu Pelajar'),
                      _buildTextField(label: 'No WA Aktif'),
                      _buildTextField(label: 'Email Aktif'),
                      _buildTextField(label: 'Keperluan'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Kirim'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                            ),
                          ),
                        ],
                      )
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
        Text(
          number,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
  

  Widget _buildTextField({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Jawaban anda',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}