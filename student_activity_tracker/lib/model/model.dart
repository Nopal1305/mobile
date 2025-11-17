class Activity {
  String name;
  String category;
  double duration; // Dalam jam, 1.0 hingga 8.0
  bool isCompleted;
  String notes;

  Activity({
    required this.name,
    required this.category,
    required this.duration,
    this.isCompleted = false,
    this.notes = '',
  });

  // Metode untuk membuat salinan Activity (berguna untuk modifikasi di masa depan,
  // atau hanya untuk kejelasan data yang diterima dari form)
  Activity copyWith({
    String? name,
    String? category,
    double? duration,
    bool? isCompleted,
    String? notes,
  }) {
    return Activity(
      name: name ?? this.name,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
