import 'package:flutter/material.dart';

class PermintaanPage extends StatelessWidget {
  const PermintaanPage({super.key});
  

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
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'PERMISI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 4.0, color: Colors.black54)],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'PERMISI (Permintaan Data di Sini) adalah tempat untuk memfasilitasi Masyarakat dalam mengajukan permintaan data dengan ketentuan dan prosedur yang ada.',
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
                //isi form
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
                        'MEKANISME PERMINTAAN DATA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('1. Isikan permintaan data dalam docs yang sudah tertera dibawah'),
                      const Text('2. Permintaan data akan diproses selama 3-5 hari kerja'),
                      const Text('3. feedback akan dikirimkan BPS Kabupaten Madiun melalui no wa aktif atau email yang telah terdaftar'),
                      const SizedBox(height: 24),
                      
                      _buildTextField(label: 'Nama Lengkap'),
                      _buildTextField(label: 'Nama Instansi'),
                      _buildTextField(label: 'No wa aktif'),
                      _buildTextField(label: 'Email aktif'),
                      _buildTextField(label: 'Data yang diminta'),
                      
                      const SizedBox(height: 16),
                      const Text('Surat Permintaan Data', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload file'),
                          ),
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