import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  // Ganti dengan API Key milikmu dari TMDB
  final String apiKey = 'd57e80c26fd2eb75310873c429a35184';
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Fungsi untuk mencari film
  Future<List<Movie>> searchMovies(String query) async {
    // 1. Siapkan URL
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');

    try {
      // 2. Minta data ke internet (GET Request)
      final response = await http.get(url);

      // 3. Cek apakah berhasil (Status 200 OK)
      if (response.statusCode == 200) {
        // Decode JSON
        final data = json.decode(response.body);
        
        // Ambil list 'results' dari JSON
        List results = data['results'];

        // Ubah setiap item JSON menjadi object Movie
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print("Error: $e");
      return []; // Kembalikan list kosong jika error
    }
  }
}