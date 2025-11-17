import 'package:flutter/material.dart';
import 'model/model.dart';
import 'add_activity_page.dart';
import 'activity_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar aktivitas yang akan ditampilkan
  List<Activity> _activities = [
    Activity(
        name: 'Belajar Flutter Dasar',
        category: 'Belajar',
        duration: 2.5,
        isCompleted: false),
    Activity(
        name: 'Lari Pagi',
        category: 'Olahraga',
        duration: 1.0,
        isCompleted: true),
  ];

  // Fungsi untuk menavigasi ke halaman form dan menerima data kembali
  void _navigateToAddActivity() async {
    final newActivity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage()),
    );

    if (newActivity != null && newActivity is Activity) {
      setState(() {
        _activities.add(newActivity);
      });
      _showSnackbar('Aktivitas "${newActivity.name}" berhasil ditambahkan!');
    }
  }

  // Fungsi untuk menavigasi ke halaman detail dan menerima hasil aksi
  void _navigateToDetail(Activity activity, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailPage(
          activity: activity,
          activityIndex: index,
        ),
      ),
    );

    if (result != null && result is Map) {
      final action = result['action'];
      final targetIndex = result['index'];

      if (action == 'delete') {
        _deleteActivity(targetIndex);
      } else if (action == 'update') {
        final updatedActivity = result['activity'] as Activity;
        // Panggil fungsi yang telah dideklarasikan
        _updateActivity(targetIndex, updatedActivity);
      }
    }
  }

  // --- FUNGSI YANG HILANG (Kini Ditambahkan) ---
  void _updateActivity(int index, Activity updatedActivity) {
    setState(() {
      // Ganti objek Activity lama dengan objek Activity yang baru (diperbarui)
      _activities[index] = updatedActivity;
    });

    final status = updatedActivity.isCompleted ? 'Selesai' : 'Belum Selesai';
    _showSnackbar('Status aktivitas "${updatedActivity.name}" diperbarui: $status.');
  }
  // ---------------------------------------------

  // Fungsi untuk menghapus aktivitas
  void _deleteActivity(int index) {
    String activityName = _activities[index].name;
    setState(() {
      _activities.removeAt(index);
    });
    _showSnackbar('Aktivitas "$activityName" berhasil dihapus.');
  }

  // Helper untuk menampilkan SnackBar
  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Activity Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _activities.isEmpty
          ? const Center(
              child: Text(
                'Belum ada aktivitas. Silakan tambahkan!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: activity.isCompleted
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => _navigateToDetail(activity, index),
                      leading: Icon(
                        activity.isCompleted
                            ? Icons.check_circle
                            : Icons.access_time,
                        color: activity.isCompleted
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text(
                        activity.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: activity.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: activity.isCompleted
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                          'Durasi: ${activity.duration} jam\nKategori: ${activity.category}'),
                      trailing: activity.isCompleted
                          ? const Chip(
                              label: Text('Selesai'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : const Chip(
                              label: Text('Belum'),
                              backgroundColor: Colors.amber,
                            ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddActivity,
        tooltip: 'Tambah Aktivitas',
        child: const Icon(Icons.add),
      ),
    );
  }
}