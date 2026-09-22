/// Modelo de domínio: representa um filme ou série no catálogo pessoal.
class Movie {
  final String id;
  final String title;
  final String genre;
  final int year;
  final double rating; // 0.0 a 10.0
  final bool watched;
  final String notes;

  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.year,
    required this.rating,
    required this.watched,
    this.notes = '',
  });

  Movie copyWith({
    String? title,
    String? genre,
    int? year,
    double? rating,
    bool? watched,
    String? notes,
  }) {
    return Movie(
      id: id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      watched: watched ?? this.watched,
      notes: notes ?? this.notes,
    );
  }
}
