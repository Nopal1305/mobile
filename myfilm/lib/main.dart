import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import file-file model & service (pastikan file ini ada)
import 'models/movie_model.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init(); // Wajib init database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Watchlist TA',
      // Tema Aplikasi: Warna Ungu Gelap biar kesan Bioskop
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light, // Bisa diganti .dark kalau mau tema gelap
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- HALAMAN UTAMA (NAVIGASI) ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SearchPage(),
    const WatchlistPage(isHistory: false),
    const WatchlistPage(isHistory: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Cari'),
          NavigationDestination(icon: Icon(Icons.movie), label: 'Watchlist'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Selesai'),
        ],
      ),
    );
  }
}

// --- HALAMAN 1: PENCARIAN ---
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _controller = TextEditingController();
  
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  void _searchMovies() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).unfocus(); // Tutup keyboard otomatis
    setState(() => _isLoading = true);
    
    try {
      final movies = await _apiService.searchMovies(_controller.text);
      setState(() => _searchResults = movies);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cari Film")),
      body: Column(
        children: [
          // Kolom Search yang lebih cantik
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari judul film...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (_) => _searchMovies(),
            ),
          ),
          
          if (_isLoading) const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),

          // LIST HASIL PENCARIAN
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                // Kita panggil Widget Custom "MovieCard"
                return MovieCard(
                  movie: movie,
                  icon: Icons.add_circle,
                  iconColor: Colors.deepPurple,
                  onIconPressed: () async {
                    await _dbService.addMovie(movie);
                    if(mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${movie.title} masuk Watchlist!")),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- HALAMAN 2 & 3: WATCHLIST & HISTORY ---
class WatchlistPage extends StatelessWidget {
  final bool isHistory;
  const WatchlistPage({super.key, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text(isHistory ? "Sudah Ditonton" : "Daftar Tontonan"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Movie>('movieBox').listenable(),
        builder: (context, Box<Movie> box, _) {
          final movies = box.values.where((m) => m.isWatched == isHistory).toList();

          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isHistory ? Icons.history_toggle_off : Icons.movie_filter_outlined, 
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(isHistory ? "Belum ada riwayat." : "Watchlist kosong.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                icon: isHistory ? Icons.delete : Icons.check_circle,
                iconColor: isHistory ? Colors.red : Colors.green,
                onIconPressed: () {
                  if (isHistory) {
                    dbService.deleteMovie(movie); // Hapus kalau di history
                  } else {
                    dbService.toggleWatchedStatus(movie); // Pindah ke history
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

// --- WIDGET BARU 1: KARTU FILM (UI KEREN) ---
class MovieCard extends StatelessWidget {
  final Movie movie;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onIconPressed;

  const MovieCard({
    super.key,
    required this.movie,
    required this.icon,
    required this.iconColor,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigasi ke Halaman Detail saat kartu diklik
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4, // Efek bayangan
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, // Agar gambar tidak keluar dari rounded corner
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // POSTER (Kiri)
            Container(
              width: 100,
              height: 150,
              color: Colors.grey[200],
              child: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_,__,___) => const Icon(Icons.broken_image),
                    )
                  : const Icon(Icons.movie, size: 50, color: Colors.grey),
            ),
            
            // INFO (Kanan)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Rilis: ${movie.releaseDate}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    // Cuplikan sinopsis (max 2 baris)
                    Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[800], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            
            // TOMBOL AKSI (Pojok Kanan)
            IconButton(
              onPressed: onIconPressed,
              icon: Icon(icon, color: iconColor, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET BARU 2: HALAMAN DETAIL FILM ---
class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Gambar yang bisa discroll (SliverAppBar)
          SliverAppBar(
            expandedHeight: 400, // Tinggi gambar header
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title, 
                style: const TextStyle(
                  color: Colors.white, 
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: movie.posterPath != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}', // Ambil resolusi lebih besar
                    fit: BoxFit.cover,
                  )
                : Container(color: Colors.grey),
            ),
          ),
          
          // Konten Deskripsi
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Tambahan
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(movie.releaseDate, style: const TextStyle(fontSize: 16)),
                      const Spacer(),
                      if (movie.isWatched)
                        const Chip(
                          label: Text("Sudah Ditonton", style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        )
                    ],
                  ),
                  const Divider(height: 30),
                  
                  const Text(
                    "Sinopsis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview.isNotEmpty ? movie.overview : "Tidak ada deskripsi.",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}