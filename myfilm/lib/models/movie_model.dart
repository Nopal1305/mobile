import 'package:hive/hive.dart';

// Baris ini wajib ada. Nama file harus sama dengan nama file dart-mu.
// Nanti akan error merah sebentar, biarkan saja dulu.
part 'movie_model.g.dart'; 

@HiveType(typeId: 0) // ID unik untuk model ini
class Movie extends HiveObject { // Extend HiveObject biar gampang delete/update
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? posterPath;

  @HiveField(3)
  final String releaseDate;

  @HiveField(4)
  final String overview;

  @HiveField(5)
  bool isWatched; // Field baru: status sudah ditonton atau belum

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.releaseDate,
    required this.overview,
    this.isWatched = false, // Default: belum ditonton (Watchlist)
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? '-',
      overview: json['overview'] ?? 'No description',
      isWatched: false,
    );
  }
}