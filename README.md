# Catálogo de Filmes e Séries

Aplicativo Flutter de catálogo pessoal de filmes e séries, desenvolvido para o trabalho final de Desenvolvimento Mobile I.

## Objetivo

Permitir que o usuário registre filmes e séries que assistiu (ou pretende assistir), com nota, gênero, ano e anotações pessoais. Funciona offline, sem cadastro, com estado local em memória.

## Como executar

1. `git clone https://github.com/David42466/Trabalho-catalogo-de-filmes-`
2. `cd Trabalho-catalogo-de-filmes-/catalogo_filmes`
3. `flutter pub get`
4. `flutter run -d web-server` (ou `-d chrome` se o Chrome estiver instalado)

## Testes

`flutter test`

## Análise estática

`flutter analyze`

## Build

`flutter build apk --release`

O APK é gerado em `build/app/outputs/flutter-apk/app-release.apk`.
