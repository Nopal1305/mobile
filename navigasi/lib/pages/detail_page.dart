import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  // Variabel untuk menerima data
  final String data;

  // Constructor untuk menerima data
  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Halaman Detail.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // Menampilkan data yang diterima
            Text(
              'Data yang diterima: $data',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('Kembali ke Halaman Sebelumnya (Pop)'),
              onPressed: () {
                // Menggunakan Navigator.pop() untuk kembali
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}