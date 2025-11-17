import 'package:flutter/material.dart';
import 'main.dart'; // Import model FeedbackData

// --- Halaman 2: Menampilkan Hasil Feedback ---
class FeedbackDisplayPage extends StatelessWidget {
  final FeedbackData data;

  const FeedbackDisplayPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Detail Feedback yang Dikirim:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const Divider(height: 30, thickness: 1.5),
                
                // Tampilkan Nama
                _buildDetailRow('Nama', data.name, Icons.person),
                const SizedBox(height: 15),

                // Tampilkan Rating
                _buildDetailRow('Rating', '${data.rating} dari 5', Icons.star, 
                                color: Colors.amber),
                const SizedBox(height: 15),

                // Tampilkan Komentar
                const Text(
                  'Komentar/Saran:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    data.comment,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Kembali
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Kembali ke halaman sebelumnya (Halaman 1)
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali ke Formulir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk baris detail
  Widget _buildDetailRow(String label, String value, IconData icon, {Color color = Colors.black}) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}