# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d linux
flutter run -d chrome
flutter run -d android

# Build
flutter build apk
flutter build linux
flutter build web

# Test
flutter test
flutter test test/widget_test.dart  # single test file

# Lint / analyze
flutter analyze

# Format
dart format lib/

# Code generation (Riverpod @riverpod annotation)
dart run build_runner build --delete-conflicting-outputs
# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs
```

## Architecture

Clean Architecture with three layers:
- `lib/features/<feature>/data/` — repositories impl, data sources, models
- `lib/features/<feature>/domain/` — entities, repository interfaces, use cases
- `lib/features/<feature>/presentation/` — widgets, pages, Riverpod providers/notifiers

Shared code lives in `lib/core/` (theme, router, constants, utils).

### State management

Use **Riverpod** (`flutter_riverpod` + `riverpod_annotation`). Prefer `@riverpod` code-gen. Wrap `runApp` with `ProviderScope`. Use `AsyncNotifier` for async state, `Notifier` for sync.

### UI

**Material 3** always. Set `useMaterial3: true` in `ThemeData`. Never use M2-only APIs (`FloatingActionButtonThemeData.sizeConstraints` etc). Use `ColorScheme.fromSeed`.

## Stack constraints

- Flutter **stable channel, v3.x**
- Dart SDK `^3.11.5`
- Target platforms: Android, iOS, Linux, macOS, Windows, Web
