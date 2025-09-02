import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _launchURL() async {
  final Uri url = Uri.parse('https://halopst.web.bps.go.id');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

class KonsultasiPage extends StatelessWidget {
  const KonsultasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/backgroundd.jpg',
            height: screenHeight * 0.4,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
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
                          'KONSULTASI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Dengan mengedepankan profesionalisme dan keterbukaan, tim ahli kami siap membantu Anda menjawab berbagai pertanyaan, baik dalam bidang statistik, survei, pengolahan data, maupun interpretasi hasil.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildConsultationCard(
                        context: context,
                        title: 'Konsultasi Langsung',
                        imagePath: 'lib/assets/konsultasi_langsung.png',
                        steps: [
                          '1. Isi Form',
                          '2. Ajukan Konsultasi',
                          '3. Jadwalkan Sesi Konsultasi',
                          '4. Terima Respon dan Solusi',
                        ],
                        buttonText: 'Isi Formulir Konsultasi',
                      ),
                      const SizedBox(height: 20),
                      _buildConsultationCard(
                        context: context,
                        title: 'Konsultasi Online',
                        imagePath: 'lib/assets/konsultasi_online.jpg',
                        steps: [
                          '1. Kunjungi Hallo PST disini',
                          '2. Buat Akun atau Login',
                          '3. Pilih Menu Konsultasi Online',
                          '4. Ajukan Konsultasi',
                          '5. Jadwalkan Sesi Konsultasi',
                          '6. Terima Respon dan Solusi',
                        ],
                        buttonText: 'Kunjungi Hallo PST',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required List<String> steps,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps
                      .map(
                        (step) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(step),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              Image.asset(imagePath, width: 100),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (title == 'Konsultasi Langsung') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormulirKonsultasiPage(),
                  ),
                );
              } else if (title == "Konsultasi Online") {
                _launchURL();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

class FormulirKonsultasiPage extends StatefulWidget {
  const FormulirKonsultasiPage({super.key});

  @override
  State<FormulirKonsultasiPage> createState() => _FormulirKonsultasiPageState();
}

class _FormulirKonsultasiPageState extends State<FormulirKonsultasiPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _instansi = TextEditingController();
  final TextEditingController _noWa = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _topik = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final format = DateFormat('dd/MM/yyyy');

  Future<void> _saveKonsul({
    required String nama,
    required String instansi,
    required String noWa,
    required String email,
    required String topik,
    required String tanggal,
  }) async {
    Timestamp tgl = Timestamp.fromDate(format.parse(tanggal));
    try {
      await firestore.collection('consult-req').add({
        'name': nama,
        'instansi': instansi,
        'phone_num': noWa,
        'email': email,
        'topik': topik,
        'date': tgl,
      });
      print('Permintaan berhasil dikirim!');
    } catch (e) {
      print('[Error] : $e');
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Stack(
          children: [
            Image.asset(
              'lib/assets/backgroundd.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              color: Colors.blue[900]!,
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        ),
        title: const Text(
          'Formulir Konsultasi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(label: 'Nama Lengkap', varText: _name),
              _buildTextField(label: 'Asal Instansi', varText: _instansi),
              _buildTextField(label: 'No WA Aktif', varText: _noWa),
              _buildTextField(label: 'Email Aktif', varText: _email),
              _buildTextField(label: 'Topik Konsultasi', varText: _topik),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal Konsultasi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            hintText: 'dd/mm/yyyy',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _saveKonsul(
                        nama: _name.text,
                        instansi: _instansi.text,
                        noWa: _noWa.text,
                        email: _email.text,
                        topik: _topik.text,
                        tanggal: _dateController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Kirim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    required TextEditingController varText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: varText,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: 'Isikan di sini...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
