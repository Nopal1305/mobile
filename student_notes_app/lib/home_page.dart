import 'package:flutter/material.dart';
import 'note_form_page.dart';
import 'note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];

  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => const NoteFormPage()),
    );

    if (result != null) {
      setState(() {
        _notes.add(result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil ditambahkan')),
      );
    }
  }

  Future<void> _editNote(int index) async {
    final current = _notes[index];

    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(existingNote: current),
      ),
    );

    if (result != null) {
      setState(() {
        _notes[index] = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil diperbarui')),
      );
    }
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // batal
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Catatan dihapus')));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Notes')),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'Belum ada catatan.\nTekan tombol + untuk menambah.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _editNote(index),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
