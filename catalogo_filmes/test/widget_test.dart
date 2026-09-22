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
