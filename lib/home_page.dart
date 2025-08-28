import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset('lib/assets/logo bps.png'),
        ),
        title: const Text('BPS Kabupaten Madiun',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(),
    );
  }
}