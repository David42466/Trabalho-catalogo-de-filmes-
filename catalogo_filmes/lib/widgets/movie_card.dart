import 'package:flutter/material.dart';
import '../models/movie.dart';

/// Widget reutilizável que representa um item da coleção (usado na
/// lista e na grade responsiva da HomeScreen).
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Semantics(
          label:
              '${movie.title}, ${movie.genre}, ${movie.year}, nota ${movie.rating.toStringAsFixed(1)}, '
              '${movie.watched ? "assistido" : "não assistido"}',
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      movie.watched
                          ? Icons.check_circle
                          : Icons.remove_circle_outline,
                      color: movie.watched
                          ? colorScheme.primary
                          : colorScheme.outline,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${movie.genre} • ${movie.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: colorScheme.tertiary),
                    const SizedBox(width: 4),
                    Text(movie.rating.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
