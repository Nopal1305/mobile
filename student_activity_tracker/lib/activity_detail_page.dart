import 'package:flutter/material.dart';
import 'model/model.dart';

class ActivityDetailPage extends StatefulWidget {
  final Activity activity;
  final int activityIndex;

  const ActivityDetailPage({
    super.key,
    required this.activity,
    required this.activityIndex,
  });

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late Activity _currentActivity;
  // State untuk melacak apakah status sudah diubah dari nilai awal
  late bool _statusChanged; 

  @override
  void initState() {
    super.initState();
    _currentActivity = widget.activity;
    _statusChanged = false; // Awalnya, status belum berubah
  }

  // Fungsi untuk menampilkan konfirmasi AlertDialog sebelum menghapus
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
            'Apakah Anda yakin ingin menghapus aktivitas "${_currentActivity.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Menghapus data: Kirim Map dengan 'action': 'delete'
              Navigator.pop(ctx); // Tutup dialog
              Navigator.pop(context, {
                'action': 'delete', 
                'index': widget.activityIndex
              }); // Kirim sinyal hapus
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
  
  // Fungsi untuk mengirim kembali perubahan status
  void _saveStatus(BuildContext context) {
    if (!_statusChanged) {
      // Jika tidak ada perubahan, langsung kembali
      Navigator.pop(context);
      return;
    }
    
    // Kirim Map dengan 'action': 'update' dan Activity yang sudah diubah
    Navigator.pop(context, {
      'action': 'update',
      'activity': _currentActivity,
      'index': widget.activityIndex,
    });
  }

  // Fungsi untuk hanya kembali tanpa menyimpan perubahan status yang belum tersimpan
  void _navigateBack(BuildContext context) {
     // Cukup pop tanpa mengirim data apapun
     Navigator.pop(context);
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memastikan status terbaru digunakan untuk tampilan
    bool statusSelesai = _currentActivity.isCompleted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Tombol kembali AppBar akan menggunakan logika _navigateBack
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                _currentActivity.name,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 40, thickness: 2),

            // Komponen: Status Aktivitas (SwitchListTile)
            SwitchListTile(
              title: const Text('Tandai Status Selesai'),
              subtitle: Text(
                  statusSelesai ? 'Sudah Selesai' : 'Belum Selesai'),
              value: statusSelesai,
              onChanged: (bool value) {
                // Menggunakan setState() lokal untuk mengubah tampilan detail
                setState(() {
                  _currentActivity = _currentActivity.copyWith(isCompleted: value);
                  // Tandai bahwa status telah diubah
                  _statusChanged = true; 
                });
              },
              secondary: Icon(
                statusSelesai ? Icons.done_all : Icons.pending_actions,
                color: statusSelesai ? Colors.green : Colors.grey,
              ),
            ),
            const Divider(height: 30),


            // Detail Item Lainnya
            _buildDetailRow(
              Icons.category,
              'Kategori',
              _currentActivity.category,
            ),
            _buildDetailRow(
              Icons.timer,
              'Durasi',
              '${_currentActivity.duration.toStringAsFixed(1)} Jam',
            ),
            _buildDetailRow(
              statusSelesai ? Icons.check_circle : Icons.pending_actions,
              'Status Saat Ini',
              statusSelesai ? 'SELESAI' : 'BELUM SELESAI',
              valueColor: statusSelesai ? Colors.green : Colors.orange,
            ),

            const Divider(height: 30),

            // Catatan Tambahan
            const Text(
              'Catatan Tambahan:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _currentActivity.notes.isNotEmpty ? _currentActivity.notes : 'Tidak ada catatan.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: _currentActivity.notes.isNotEmpty
                      ? FontStyle.normal
                      : FontStyle.italic,
                  color: _currentActivity.notes.isNotEmpty
                      ? Colors.black
                      : Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 50),
            
            // TOMBOL BARU: Simpan Aktivitas Selesai (atau status terbaru)
            ElevatedButton.icon(
              onPressed: _statusChanged ? () => _saveStatus(context) : null, // Disabled jika tidak ada perubahan
              icon: const Icon(Icons.save),
              label: const Text('Simpan Status Aktivitas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _statusChanged ? Colors.deepPurple : Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
            const SizedBox(height: 15),

            // Tombol "Kembali" (Navigator.pop(context))
            OutlinedButton.icon(
              onPressed: () => _navigateBack(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali (Tanpa Menyimpan)'),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45)),
            ),
            const SizedBox(height: 15),

            // Tombol "Hapus Aktivitas"
            ElevatedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Hapus Aktivitas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}