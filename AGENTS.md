# AGENTS.md

Companion to `CLAUDE.md` (commands, architecture layers, Riverpod/Freezed/Material 3 rules, stack pins live there). This file adds the things an agent would otherwise miss or get wrong on this repo.

## Verify, don't guess

The repo is small but the file tree is not a faithful map of what runs:

- `test/` does **not** exist yet. `flutter test` will pass with zero tests, and `flutter test test/widget_test.dart` (shown in `CLAUDE.md`) will fail. Don't scaffold tests under that path without checking.
- Only one feature (`auth`) is implemented under `lib/features/`. The `data/`, `domain/`, `presentation/` skeleton exists; new features must follow the same shape.
- No CI (`.github/` empty), no pre-commit hooks (`.git/hooks/` only contains samples), no repo-local `opencode.json`. Don't search for them.

## Code generation is required, not optional

Generated files are **checked in**:

- `*.g.dart` — `riverpod_generator` (`@riverpod`) and `json_serializable` (`@JsonSerializable`).
- `*.freezed.dart` — `freezed` (`@freezed` unions and data classes).

After editing any annotated source, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Use `dart run build_runner watch --delete-conflicting-outputs` while iterating. Commit the regenerated files alongside your source changes — reviewers will reject the diff otherwise. If `build_runner` fails on Riverpod providers, the likely cause is a missing `part 'foo.g.dart';` directive, not a real type error.

## API endpoint configuration

The base URL is hardcoded to production (`https://saets.nullpointer.us.kg/api/v1`) in two places: `lib/main.dart::_resolveEndpoint()` and `lib/core/constants/api_constants.dart` (`static String baseUrl`). `main()` calls `DioClient.updateBaseUrl(...)` before `runApp` to sync both. There is no `--dart-define=API_BASE_URL` override anymore — to switch to a local backend, edit `_resolveEndpoint()`. Endpoint paths (`/auth/login`, `/auth/register`, `/auth/me`, `/auth/logout`) are constants in `api_constants.dart` — add new endpoints there, not inline in datasources.

## Auth wiring (read this before touching auth code)

The pieces are coupled in a non-obvious way:

- `lib/main.dart` calls `ref.read(authProvider.notifier).checkAuthStatus()` in a post-frame callback.
- `Auth` notifier (`@riverpod class Auth`) **constructs and registers** the `AuthInterceptor` inside `build()` via `DioClient.addAuthInterceptor(...)`. Adding a second notifier that builds its own interceptor will double-register it on the singleton `Dio` — do not do that.
- `goRouterProvider` (`lib/core/router/app_router.dart`) watches `authProvider` and uses `maybeWhen` to drive redirects. Initial location is `/home`; the redirect sends unauthenticated users to `/login`.
- The `DioClient` singleton adds a request/response `LogInterceptor` only in `kDebugMode`. Don't add `print` debugging in production code.
- Token storage keys: secure-storage key is `auth_token` (see `AuthInterceptor._storage`); biometric toggle is a separate flag managed by `AuthRepository`.

When adding a new HTTP client feature, depend on the same `DioClient.instance` and let the existing interceptor handle auth.

## Platform / build notes

- Target platforms per `pubspec.yaml`: Android, iOS, Linux, macOS, Windows, Web. The Android manifest already declares the permissions `local_auth` and `flutter_secure_storage` need — verify after a `flutter clean` if biometrics or secure storage misbehave on device.
- `assets/` currently ships only `AM_InicioSesion.webp`. New static assets must be listed under `flutter.assets:` in `pubspec.yaml`.
- `pubspec.lock` is committed — run `flutter pub get` after pulling, not `pub upgrade`, unless the task is a deliberate dep bump.

## Conventions specific to this repo

- Spanish for user-facing strings and `debugPrint` messages; English for code, identifiers, and doc comments. Match the existing files.
- Do **not** add code comments. The system instruction for this project is "DO NOT ADD ANY COMMENTS unless asked."
- Prefer `ColorScheme.fromSeed` with the existing `#D96704` seed unless the task is to rebrand.
- `custom_lint` + `riverpod_lint` are enabled (`analysis_options.yaml`); `flutter analyze` will flag deprecated Riverpod APIs (`ref.watch` on providers, manual `StateProvider`, etc.) — use the code-gen forms.

## Recommended order before declaring done

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
dart format lib/
flutter test        # currently zero tests; failure here means you broke the toolchain, not a real regression
```
