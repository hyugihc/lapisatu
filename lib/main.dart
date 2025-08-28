import 'package:flutter/material.dart';
import 'loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapis Satu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingScreen(),
    );
  }
}

// Halaman utama placeholder sebagai tujuan navigasi
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Screen'),
      ),
      body: const Center(
        child: Text(
          'Selamat Datang di LAPIS SATU',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  } 
}