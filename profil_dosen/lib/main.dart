import 'package:flutter/material.dart';
import 'second_page.dart'; // Import halaman kedua

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Profil Dosen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: const DosenProfileListScreen(),
    );
  }
}

// --- DATA PROFIL DOSEN ---
class Dosen {
  final String name;
  final String nidn;
  final String photoUrl;
  final String bidang;
  final String email;

  Dosen({
    required this.name,
    required this.nidn,
    required this.photoUrl,
    required this.bidang,
    required this.email,
  });
}

final List<Dosen> dosenList = [
  Dosen(
    name: 'WAHYU ANGGORO, M.Kom',
    nidn: '1571082309960021',
    photoUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
    bidang: 'Manajemen Resiko',
    email: '..........',
  ),
  Dosen(
    name: 'AHMAD NASUKHA, S.Hum., M.S.I',
    nidn: '1988072220171009',
    photoUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140037.png',
    bidang: 'Pemrograman Mobile',
    email: '...........',
  ),
  Dosen(
    name: 'POL METRA, M.Kom',
    nidn: '19910615010122045',
    photoUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140059.png',
    bidang: 'Multimedia',
    email: '...........',
  ),
  Dosen(
    name: 'DILA NURLAILA, M.Kom',
    nidn: '1571015201960020',
    photoUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140051.png',
    bidang: 'Rekayasa Perangkat Lunak',
    email: '...........',
  ),
  Dosen(
    name: 'M. YUSUF, S.Kom., M.S.I',
    nidn: '1988021420191007',
    photoUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140064.png',
    bidang: 'Technopreneurship',
    email: '...........',
  ),
  Dosen(
    name: 'FATIMA FELAWATI, S.Kom., M.Kom',
    nidn: '199305112025052004',
    photoUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140071.png',
    bidang: 'Testing dan Implementasi Sistem',
    email: '...........',
  ),
];

// --- HALAMAN UTAMA (DAFTAR PROFIL) ---
class DosenProfileListScreen extends StatelessWidget {
  const DosenProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Profil Dosen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dosenList.length,
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          return Card(
            elevation: 4,
            shadowColor: Colors.indigo.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Hero(
                tag: dosen.name,
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(dosen.photoUrl),
                ),
              ),
              title: Text(
                dosen.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text("Bidang: ${dosen.bidang}"),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigoAccent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DosenDetailScreen(dosen: dosen),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
