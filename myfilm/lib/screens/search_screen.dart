import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Inisialisasi Service
  final ApiService apiService = ApiService();
  
  // Variabel penampung hasil
  List<Movie> movies = [];
  bool isLoading = false;

  // Fungsi yang dipanggil saat tombol cari ditekan
  void _search(String query) async {
    setState(() => isLoading = true); // Mulai loading
    
    final results = await apiService.searchMovies(query);
    
    setState(() {
      movies = results;
      isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cari Film (TMDB)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kolom Pencarian
            TextField(
              decoration: const InputDecoration(
                hintText: 'Ketik judul film (misal: Avenger)...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) => _search(value), // Enter ditekan
            ),
            const SizedBox(height: 20),
            
            // Loading Indicator atau Hasil List
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: movie.posterPath != null
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.movie), // Gambar pengganti
                          title: Text(movie.title),
                          subtitle: Text(movie.releaseDate),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              // DISINI NANTI LOGIKA SAVE KE DATABASE
                              print("Simpan ${movie.title}");
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}