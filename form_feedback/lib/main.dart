import 'package:flutter/material.dart';
import 'feedback_display_page.dart';

void main() {
  runApp(const FormFeedbackApp());
}

// Model data untuk feedback
class FeedbackData {
  String name;
  String comment;
  int rating;

  FeedbackData({
    required this.name,
    required this.comment,
    required this.rating,
  });
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FeedbackFormPage(),
    );
  }
}

// --- Halaman 1: Formulir Feedback (StatefulWidget) ---
class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  // Controller untuk TextFormField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  
  // Variabel state untuk rating
  int _currentRating = 3; // Nilai default 3

  // Kunci global untuk validasi formulir
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Fungsi untuk menangani pengiriman formulir
  void _submitFeedback() {
    // Validasi formulir
    if (_formKey.currentState!.validate()) {
      // Ambil data dari state dan controller
      final feedbackData = FeedbackData(
        name: _nameController.text,
        comment: _commentController.text,
        rating: _currentRating,
      );

      // Navigasi ke Halaman 2 dan kirim data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackDisplayPage(data: feedbackData),
        ),
      );
    }
  }

  // Fungsi untuk memperbarui rating saat tombol ditekan
  void _updateRating(int newRating) {
    setState(() {
      _currentRating = newRating;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Feedback'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Input Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Komentar
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar/Saran',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Komentar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Rating (Real-time update dengan setState)
              Text('Rating: ($_currentRating dari 5)', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  int ratingValue = index + 1;
                  return ElevatedButton(
                    onPressed: () => _updateRating(ratingValue),
                    style: ElevatedButton.styleFrom(
                      // Mengubah warna tombol berdasarkan state
                      backgroundColor: ratingValue == _currentRating 
                          ? Colors.amber 
                          : Colors.grey,
                      foregroundColor: Colors.black,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                    ),
                    child: Text(
                      '$ratingValue',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // Tombol Kirim
              ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send),
                label: const Text(
                  'Kirim Feedback',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}