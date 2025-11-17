import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DosenDetailScreen extends StatelessWidget {
  final dynamic dosen;

  const DosenDetailScreen({Key? key, required this.dosen}) : super(key: key);

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label disalin ke clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Profil Dosen'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: dosen.name,
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.indigo.withOpacity(0.1),
                backgroundImage: NetworkImage(dosen.photoUrl),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dosen.name,
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              dosen.bidang ?? '',
              style: textTheme.bodyMedium?.copyWith(color: Colors.indigoAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge_outlined, color: Colors.indigoAccent),
                    title: const Text('NIDN'),
                    subtitle: Text(dosen.nidn ?? ''),
                    onLongPress: () {
                      _copyToClipboard(context, dosen.nidn ?? '', 'NIDN');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.work_outline, color: Colors.indigoAccent),
                    title: const Text('Bidang'),
                    subtitle: Text(dosen.bidang ?? ''),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email_outlined, color: Colors.indigoAccent),
                    title: const Text('Email'),
                    subtitle: SelectableText(dosen.email ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, color: Colors.indigoAccent),
                      onPressed: () => _copyToClipboard(context, dosen.email ?? '', 'Email'),
                      tooltip: 'Salin email',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}