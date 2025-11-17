import 'package:flutter/material.dart';
import 'model/model.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _formKey = GlobalKey<FormState>();

  // State untuk data input
  String _activityName = '';
  String _activityCategory = 'Belajar'; // Nilai default
  double _duration = 1.0; // Nilai default Slider (1 jam)
  // Menghapus: bool _isCompleted = false;
  String _notes = '';

  final List<String> _categories = [
    'Belajar',
    'Ibadah',
    'Olahraga',
    'Hiburan',
    'Lainnya'
  ];

  void _submitForm() {
    // Memastikan form divalidasi dengan validator field
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
       // 📌 Validasi: Nama kosong -> tampilkan AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kesalahan Input'),
          content: const Text('Nama Aktivitas wajib diisi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Hentikan proses jika validasi gagal
    }

    // Jika valid, buat objek Activity baru
    final newActivity = Activity(
      name: _activityName,
      category: _activityCategory,
      duration: _duration,
      isCompleted: false, // Status selalu FALSE (Belum Selesai) saat baru dibuat
      notes: _notes,
    );

    // Kirim data kembali ke HomePage
    Navigator.pop(context, newActivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Aktivitas Baru'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Komponen: Nama Aktivitas (TextField)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Aktivitas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                onChanged: (value) {
                  _activityName = value;
                },
                onSaved: (value) {
                  _activityName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama aktivitas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Komponen: Kategori Aktivitas (DropdownButtonFormField)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori Aktivitas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _activityCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _activityCategory = newValue!;
                  });
                },
                onSaved: (value) {
                  _activityCategory = value!;
                },
              ),
              const SizedBox(height: 20),

              // Komponen: Durasi (Jam) (Slider)
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Durasi: ${_duration.toStringAsFixed(1)} Jam',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: _duration,
                        min: 1.0,
                        max: 8.0,
                        divisions: 14,
                        label: _duration.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          setState(() {
                            _duration = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // >>> CATATAN: SwitchListTile dihapus dari sini

              // Komponen: Catatan Tambahan (TextField multiline)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan (Optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note_alt),
                ),
                maxLines: 3,
                onChanged: (value) {
                  _notes = value;
                },
                onSaved: (value) {
                  _notes = value!;
                },
              ),
              const SizedBox(height: 30),

              // Komponen: Tombol Simpan (ElevatedButton)
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Aktivitas'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}