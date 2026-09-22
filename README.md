# Catálogo de Filmes e Séries — passo a passo

Estes arquivos (`lib/`, `test/`, `.devcontainer/`) são para você colar
DENTRO de um projeto Flutter recém-criado. Eles não substituem o
`flutter create`, que gera as pastas `android/`, `ios/`, `web/` etc.
que você precisa para o `flutter build apk`.

## 1. Criar o repositório

1. Crie um repositório público no GitHub, ex: `catalogo-filmes-flutter`.
2. Não adicione README nem .gitignore pelo GitHub (vamos gerar tudo pelo Codespaces).

## 2. Abrir o Codespace

1. No repositório: **Code > Codespaces > Create codespace on main**.
2. Assim que abrir, cole a pasta `.devcontainer/` deste pacote na raiz do
   repositório, faça commit e reconstrua o container
   (`Ctrl+Shift+P` > "Codespaces: Rebuild Container").
   Isso instala Flutter + Android SDK automaticamente (imagem
   `cirruslabs/flutter`), sem você baixar nada no seu PC.

## 3. Criar o projeto Flutter

No terminal do Codespace:

```bash
flutter create --org com.exemplo catalogo_filmes
```

Isso cria a pasta `catalogo_filmes/` com `pubspec.yaml`, `android/`, `web/` etc.

Agora **substitua** o conteúdo de `catalogo_filmes/lib/` e
`catalogo_filmes/test/` pelos arquivos deste pacote (`lib/` e `test/`),
e copie o `.devcontainer/` para a raiz do repositório (fora da pasta do projeto),
se ainda não tiver copiado.

Confira que `pubspec.yaml` tem `name: catalogo_filmes` (os imports do
`widget_test.dart` usam `package:catalogo_filmes/...`).

## 4. Rodar no Chrome (sem emulador)

```bash
cd catalogo_filmes
flutter run -d chrome
```

O Codespaces abre uma aba com o link — clique e o app roda no seu
navegador local. Redimensione a janela (ou use F12 > modo responsivo)
para simular celular e tablet e capturar os dois espaços de tela pedidos.

## 5. Análise e testes

```bash
flutter analyze
flutter test
```

Copie a saída do terminal (sem erros) para o relatório como evidência.

## 6. Gerar o APK

```bash
flutter build apk --release
```

O arquivo fica em `build/app/outputs/flutter-apk/app-release.apk`.
Não precisa baixar: um print do comando terminando com sucesso e o
caminho do arquivo já serve como evidência no PDF.

## 7. Commit, push e link no PDF

```bash
git add .
git commit -m "M1: catálogo de filmes e séries"
git push
```

Pegue o hash do commit (`git rev-parse HEAD`) ou crie uma tag e informe
os dois no PDF (seção 2 do modelo).

---

## Mapeamento para os 13 critérios da rubrica

| Nº | Critério | Onde está no código |
|----|----------|----------------------|
| 4 | 2+ telas e navegação | `HomeScreen` → `DetailScreen` → `FormScreen` (Navigator.push) |
| 5 | Coleção dinâmica + estado vazio | `HomeScreen._movies` (lista) + `EmptyState` |
| 6 | Detalhe do item | `DetailScreen` |
| 7 | Formulário e validação | `FormScreen` (validators + SnackBar de erro) |
| 8 | Criação e edição no estado local | `HomeScreen._openForm` / `_openDetail` (setState) |
| 9 | Modelo e widgets organizados | `models/movie.dart`, `widgets/movie_card.dart`, `widgets/empty_state.dart` |
| 10 | Dois espaços sem overflow | `HomeScreen` (`LayoutBuilder` — lista vs. grade) |
| 11 | Tema e acessibilidade | `main.dart` (Material 3, ColorScheme) + `Semantics` no `MovieCard` |
| 12 | Análise e teste de widget | `test/widget_test.dart` + saída de `flutter analyze`/`flutter test` |

Os critérios 1, 2, 3 e 13 são sobre o texto do relatório em si (resumo,
link do repositório, instruções de execução, decisões/fontes/autoria) —
preencha diretamente no PDF modelo com base no que você fez aqui.

**Importante:** o campo "domínio e problema" (seção 1 do relatório) e as
"decisões técnicas" (seção 6) precisam ser escritos com suas palavras,
explicando as escolhas que você fez — isso o professor vai notar se for
genérico demais.
