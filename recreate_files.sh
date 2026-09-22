mkdir -p catalogo_filmes/lib/models catalogo_filmes/lib/widgets catalogo_filmes/lib/screens catalogo_filmes/test
cat > catalogo_filmes/lib/main.dart << 'DARTEOF'
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CatalogoApp());
}

class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return MaterialApp(
      title: 'Catálogo de Filmes e Séries',
      debugShowCheckedModeBanner: false,
      // Tema Material 3 com contraste adequado e tamanho de toque padrão
      // (>=48dp nos botões do Material), atendendo aos cuidados de acessibilidade.
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
DARTEOF
cat > catalogo_filmes/lib/models/movie.dart << 'DARTEOF'
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
DARTEOF
cat > catalogo_filmes/lib/widgets/movie_card.dart << 'DARTEOF'
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
DARTEOF
cat > catalogo_filmes/lib/widgets/empty_state.dart << 'DARTEOF'
import 'package:flutter/material.dart';

/// Widget reutilizável exibido quando a coleção não tem itens.
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    this.message = 'Sua coleção está vazia.\nToque em "+" para adicionar.',
    this.icon = Icons.movie_filter_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
DARTEOF
cat > catalogo_filmes/lib/screens/home_screen.dart << 'DARTEOF'
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
DARTEOF
cat > catalogo_filmes/lib/screens/detail_screen.dart << 'DARTEOF'
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
DARTEOF
cat > catalogo_filmes/lib/screens/form_screen.dart << 'DARTEOF'
import 'package:flutter/material.dart';
import '../models/movie.dart';

/// Formulário usado tanto para criar quanto para editar um item.
/// Se [movie] for nulo, é criação; caso contrário, é edição.
class FormScreen extends StatefulWidget {
  final Movie? movie;

  const FormScreen({super.key, this.movie});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _genreController;
  late TextEditingController _yearController;
  late TextEditingController _ratingController;
  late TextEditingController _notesController;
  late bool _watched;

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _titleController = TextEditingController(text: m?.title ?? '');
    _genreController = TextEditingController(text: m?.genre ?? '');
    _yearController = TextEditingController(text: m?.year.toString() ?? '');
    _ratingController =
        TextEditingController(text: m?.rating.toString() ?? '');
    _notesController = TextEditingController(text: m?.notes ?? '');
    _watched = m?.watched ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _yearController.dispose();
    _ratingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: widget.movie?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        genre: _genreController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        rating: double.parse(_ratingController.text.trim().replaceAll(',', '.')),
        watched: _watched,
        notes: _notesController.text.trim(),
      );
      Navigator.pop(context, movie);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Corrija os campos destacados antes de salvar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar item' : 'Novo item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o título.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o gênero.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ano',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final year = int.tryParse(value?.trim() ?? '');
                if (year == null) return 'Informe um ano válido.';
                if (year < 1888 || year > DateTime.now().year + 1) {
                  return 'Ano fora do intervalo esperado.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ratingController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Nota (0 a 10)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final rating =
                    double.tryParse((value ?? '').trim().replaceAll(',', '.'));
                if (rating == null) return 'Informe uma nota válida.';
                if (rating < 0 || rating > 10) {
                  return 'A nota deve estar entre 0 e 10.';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Já assisti'),
              value: _watched,
              onChanged: (value) => setState(() => _watched = value),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Salvar alterações' : 'Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
DARTEOF
cat > catalogo_filmes/test/widget_test.dart << 'DARTEOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_filmes/widgets/empty_state.dart';
import 'package:catalogo_filmes/screens/form_screen.dart';

void main() {
  testWidgets('EmptyState mostra ícone e mensagem quando a coleção está vazia',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmptyState())),
    );

    expect(find.byIcon(Icons.movie_filter_outlined), findsOneWidget);
    expect(find.textContaining('coleção está vazia'), findsOneWidget);
  });

  testWidgets(
      'FormScreen mostra mensagem de erro ao tentar salvar com campos inválidos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormScreen()));

    // Tenta salvar sem preencher nada.
    await tester.tap(find.text('Adicionar'));
    await tester.pump();

    expect(find.text('Informe o título.'), findsOneWidget);
    expect(find.text('Informe o gênero.'), findsOneWidget);
  });
}
DARTEOF
