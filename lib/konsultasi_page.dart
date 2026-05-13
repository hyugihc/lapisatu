import 'package:flutter/material.dart';
import 'package:lapis_satu/atoms/func_utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'send_notif.dart';

Future<void> _launchURL() async {
  final Uri url = Uri.parse('https://halopst.web.bps.go.id');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Future<void> _launchWhatsAppPesilat() async {
  final Uri url = Uri.parse('https://wa.me/6281235113519');
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
                      const SizedBox(height: 20),
                      _buildPesilatContactCard(),
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

  Widget _buildPesilatContactCard() {
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
          const Text(
            'Hubungi PESILAT',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Pelayanan Data dan Pengaduan Singkat Lengkap Cepat'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _launchWhatsAppPesilat,
            icon: const Icon(Icons.chat),
            label: const Text('+6281235113519'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
            ),
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

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _saveKonsul({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String nama = _name.text;
      String instansi = _instansi.text;
      String noWa = _noWa.text;
      String email = _email.text;
      String topik = _topik.text;
      String tanggal = _dateController.text;
      Timestamp tgl = Timestamp.fromDate(format.parse(tanggal));
      try {
        await firestore.collection('consult-req').add({
          'name': nama,
          'instansi': instansi,
          'phone_num': noWa,
          'email': email,
          'topik': topik,
          'date': tgl,
          'timestamp': FieldValue.serverTimestamp(),
          'title': 'Konsultasi',
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

        sendNotificationV1(
          title: 'Permintaan Konsultasi',
          body: 'Permintaan konsultasi dari $nama telah masuk',
        );

        setState(() {
          _isLoading = false;
        });
        if (!context.mounted) return;
        Navigator.of(context).pop();
      } catch (e) {
        // print('[Error] : $e');

        if (!context.mounted) return;

        _showStatusDialog(
          context,
          icon: Icons.highlight_off,
          color: Colors.red,
          message: 'Gagal Terkirim\nSilakan Coba Lagi',
        );
        setState(() {
          _isLoading = false;
        });
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
  void dispose() {
    _name.dispose();
    _instansi.dispose();
    _noWa.dispose();
    _email.dispose();
    _topik.dispose();
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
      appBar: generateAppBar(
        title: 'Formulir Konsultasi',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                generateInputField(
                  label: 'Nama Lengkap',
                  varText: _name,
                  validator: ValidatorInput.defaultRequired,
                ),
                generateInputField(
                  label: 'Asal Instansi',
                  varText: _instansi,
                  validator: ValidatorInput.defaultRequired,
                ),
                generateInputField(
                  label: 'No. WA Aktif',
                  varText: _noWa,
                  validator: ValidatorInput.validatePhoneNumber,
                ),
                generateInputField(
                  label: 'Email',
                  varText: _email,
                  validator: ValidatorInput.validateEmail,
                ),
                generateInputField(
                  label: 'Topik Konsultasi',
                  varText: _topik,
                  validator: ValidatorInput.defaultRequired,
                ),

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
                          TextFormField(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal konsultasi wajib dipilih.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _saveKonsul(context: context);
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
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text('Kirim Penjadwalan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
