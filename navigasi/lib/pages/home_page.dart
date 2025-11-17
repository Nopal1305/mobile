import 'package:flutter/material.dart';
import 'detail_page.dart'; // Pastikan file detail_page.dart ada

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data yang akan dikirim ke halaman DetailPage
    const String dataKirim = 'Halo dari Halaman Beranda!';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Selamat Datang di Halaman Beranda',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Pergi ke Detail (Push & Kirim Data)'),
            onPressed: () {
              // Menggunakan Navigator.push() untuk berpindah halaman
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Meneruskan data melalui constructor DetailPage
                  builder: (context) => const DetailPage(data: dataKirim),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}