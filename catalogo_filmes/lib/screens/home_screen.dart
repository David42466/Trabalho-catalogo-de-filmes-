import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/empty_state.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

/// Tela inicial: guarda a coleção em estado local e decide o layout
/// (lista ou grade) conforme a largura disponível, evitando overflow
/// tanto em telas estreitas (celular) quanto largas (tablet/desktop).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Movie> _movies = [
    const Movie(
      id: '1',
      title: 'A Chegada',
      genre: 'Ficção científica',
      year: 2016,
      rating: 8.5,
      watched: true,
      notes: 'Ótima trilha sonora e roteiro.',
    ),
    const Movie(
      id: '2',
      title: 'Breaking Bad',
      genre: 'Drama',
      year: 2008,
      rating: 9.5,
      watched: false,
    ),
  ];

  Future<void> _openForm() async {
    final newMovie = await Navigator.push<Movie>(
      context,
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
    if (newMovie != null) {
      setState(() => _movies.add(newMovie));
    }
  }

  Future<void> _openDetail(Movie movie) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
    );
    if (result == null) return;

    setState(() {
      if (result['action'] == 'delete') {
        _movies.removeWhere((m) => m.id == movie.id);
      } else if (result['action'] == 'update') {
        final updated = result['movie'] as Movie;
        final index = _movies.indexWhere((m) => m.id == updated.id);
        if (index != -1) _movies[index] = updated;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu catálogo de filmes e séries')),
      body: _movies.isEmpty
          ? const EmptyState()
          : LayoutBuilder(
              builder: (context, constraints) {
                // Espaço largo (tablet/web) -> grade; espaço estreito (celular) -> lista.
                final isWide = constraints.maxWidth >= 600;
                if (isWide) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 260,
                      mainAxisExtent: 150,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) => MovieCard(
                      movie: _movies[index],
                      onTap: () => _openDetail(_movies[index]),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _movies.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MovieCard(
                      movie: _movies[index],
                      onTap: () => _openDetail(_movies[index]),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        tooltip: 'Adicionar novo item ao catálogo',
      ),
    );
  }
}
