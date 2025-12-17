import 'package:flutter/material.dart';
import 'note.dart';

class NoteFormPage extends StatefulWidget {
  final Note? existingNote;

  const NoteFormPage({super.key, this.existingNote});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  bool get isEditMode => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final newNote = Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );

    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Catatan' : 'Catatan Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Judul wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Isi catatan tidak boleh kosong'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: Text(isEditMode ? 'Simpan Perubahan' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
