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
