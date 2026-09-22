import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'form_screen.dart';

/// Exibe os detalhes de um item selecionado, com ações de editar e remover.
class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('${movie.genre} • ${movie.year}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star),
                const SizedBox(width: 6),
                Text('Nota: ${movie.rating.toStringAsFixed(1)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(movie.watched ? Icons.check_circle : Icons.remove_circle_outline),
                const SizedBox(width: 6),
                Text(movie.watched ? 'Assistido' : 'Não assistido'),
              ],
            ),
            if (movie.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Notas', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(movie.notes),
            ],
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    onPressed: () async {
                      final updated = await Navigator.push<Movie>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormScreen(movie: movie),
                        ),
                      );
                      if (updated != null && context.mounted) {
                        Navigator.pop(context, {'action': 'update', 'movie': updated});
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remover'),
                    onPressed: () {
                      Navigator.pop(context, {'action': 'delete', 'movie': movie});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
