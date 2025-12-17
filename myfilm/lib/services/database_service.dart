import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_model.dart';

class DatabaseService {
  // Nama kotak penyimpanan (Box)
  static const String boxName = 'movieBox';

  // 1. Inisialisasi Database (Panggil di main.dart nanti)
  static Future<void> init() async {
    await Hive.initFlutter();
    // Daftarkan Adapter yang tadi digenerate
    Hive.registerAdapter(MovieAdapter()); 
    // Buka kotak penyimpanan
    await Hive.openBox<Movie>(boxName);
  }

  // Ambil box agar bisa dipakai fungsi lain
  Box<Movie> get _box => Hive.box<Movie>(boxName);

  // 2. CREATE: Simpan Film ke Watchlist
  Future<void> addMovie(Movie movie) async {
    // Cek dulu biar gak simpan film yang sama double
    if (!_box.containsKey(movie.id)) {
      await _box.put(movie.id, movie); // Simpan pakai ID sebagai key
    }
  }

  // 3. READ: Ambil semua film
  List<Movie> getMovies() {
    return _box.values.toList();
  }

  // 4. UPDATE: Ganti status jadi "Sudah Ditonton"
  Future<void> toggleWatchedStatus(Movie movie) async {
    movie.isWatched = !movie.isWatched; // Balik status (true jadi false, false jadi true)
    await movie.save(); // Fitur canggih HiveObject, bisa save diri sendiri
  }

  // 5. DELETE: Hapus film
  Future<void> deleteMovie(Movie movie) async {
    await movie.delete();
  }
}