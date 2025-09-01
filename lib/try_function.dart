import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GontaGanti extends StatefulWidget {
  const GontaGanti({super.key});

  @override
  State<GontaGanti> createState() => _GontaGanti();
}

class _GontaGanti extends State<GontaGanti> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _noWa = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _keperluan = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = '';
  bool vsbl = false;

  Future<void> permintaanMagang(
    String name,
    String nik,
    String nowa,
    String email,
  ) async {
    try {
      await firestore.collection('intern-req').add({
        'nama': name,
        'identity_num': nik,
        'phone_num': nowa,
        'email': email,
      });
      print('Permintaan berhasil terkirim!');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Container'),
        backgroundColor: Color(0xff8888ff),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Center(
                child: const Text(
                  'Mekanisme Permintaan Data',
                  style: TextStyle(
                    color: Color(0xff022B6A),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _name,
                          // Gunakan decoration untuk styling
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Nama Lengkap',
                            hintText: 'Masukkan nama Anda di sini',
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _nik,
                          // Gunakan decoration untuk styling
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'NIK/Nomor Kartu Pelajar',
                            hintText: 'Masukkan nama instansi Anda di sini',
                            prefixIcon: const Icon(Icons.badge),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _noWa,
                          // Gunakan decoration untuk styling
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Nomor WhatsApp',
                            hintText: 'Masukkan nomor WhatsApp Anda di sini',
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _email,
                          // Gunakan decoration untuk styling
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'E-mail',
                            hintText: 'Masukkan Email Anda di sini',
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _keperluan,
                          // Gunakan decoration untuk styling
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Keperluan',
                            hintText: 'Masukkan Keperluan Anda di sini',
                            prefixIcon: const Icon(Icons.subject),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              permintaanMagang(
                                _name.text,
                                _nik.text,
                                _noWa.text,
                                _email.text,
                              );
                            });
                          },
                          child: const Text('Konfirmasi'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: vsbl,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(children: [Text(name)]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xffe0e0e0),
    );
  }
}
