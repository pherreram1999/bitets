# Plan: Alinear auth con API real (Sanctum + identificador/boleta)

## Contexto

La app actualmente envía `{ email, password }` al login y `{ name, email, password, password_confirmation }` al registro. La API real (http://127.0.0.1:8000/api.json) espera campos diferentes: `identificador` (boleta) en lugar de `email` para login, y `identificador` + `rol` para registro. Además, la API devuelve `{ user, token }` en ambos endpoints (login y registro), el token es un Sanctum personal access token, y `device_name` es requerido.

## Discrepancias detectadas

| Concepto | Código actual | API real |
|---|---|---|
| Login envía | `{ email, password }` | `{ identificador, password, device_name }` |
| Register envía | `{ name, email, password, password_confirmation }` | `{ name, email, identificador, password, password_confirmation, rol? }` |
| Register devuelve | Solo `token` (string) | `{ user: UserResource, token }` |
| UserResource | No tiene `identificador` | Incluye `identificador` (string\|null) |
| Base URL default | `http://bitets.test/api/v1` | `http://127.0.0.1:8000/api/v1` |
| Roles API | — | `admin`, `profesor`, `alumno` (default: alumno) |

## Cambios por archivo

### 1. `pubspec.yaml`
Agregar dependencia `device_info_plus: ^11.3.3` para obtener nombre del dispositivo físico.

### 2. `lib/core/constants/api_constants.dart`
- `baseUrl` pasa de `const String` a `static String` mutable
- Default: `http://127.0.0.1:8000/api/v1`
- Eliminar `String.fromEnvironment` (reemplazado por propiedad estática en main.dart)

### 3. `lib/main.dart`
- Agregar `const String _endpoint = 'http://127.0.0.1:8000/api/v1';` como propiedad estática
- Llamar `DioClient.updateBaseUrl(_endpoint)` antes de `runApp`
- Importar `api_constants.dart` y `dio_client.dart`

### 4. `lib/core/network/dio_client.dart`
- Agregar método `static void updateBaseUrl(String url)` que actualiza `ApiConstants.baseUrl` y `instance.options.baseUrl`

### 5. `lib/features/auth/data/models/login_request.dart`
- Campo `email` → `identificador`
- Agregar campo `deviceName` (serializa como `device_name`)
- `toJson()` envía `{ identificador, password, device_name }`

### 6. `lib/features/auth/data/models/register_request.dart`
- Agregar campo `identificador` (requerido)
- Agregar campo `rol` (opcional, default `'alumno'`)
- `toJson()` envía `{ name, email, identificador, password, password_confirmation, rol }`

### 7. `lib/features/auth/domain/entities/user.dart`
- Agregar campo `identificador` (String?, nullable)
- Regenerar `user.g.dart`

### 8. `lib/features/auth/data/models/user_model.dart`
- Agregar campo `identificador` (String?, nullable)
- Actualizar `toEntity()` y `fromEntity()` para incluir `identificador`
- Regenerar `user_model.g.dart`

### 9. `lib/features/auth/domain/repositories/auth_repository.dart`
- `login`: parámetro `email` → `identificador`
- `register`: agregar parámetro `identificador` y `rol` opcional (default `'alumno'`)

### 10. `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `login`: pasar `identificador` + `deviceName` al `LoginRequest`
- `register`: pasar `identificador` + `rol` al `RegisterRequest`; ya no necesita llamar `getCurrentUser()` después (la API devuelve user + token)
- Obtener device name con `device_info_plus` (fallback a `Platform` en desktop/web)

### 11. `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `register` devuelve `AuthResponseModel` (no `String`), igual que `login`
- `login` pasa `device_name` en el request

### 12. `lib/features/auth/presentation/providers/auth_provider.dart`
- `login(String identificador, String password)` en lugar de `login(String email, String password)`
- `register(String name, String email, String identificador, String password, String passwordConfirmation)` — agregar `identificador`
- Simplificar `register`: usar user devuelto por la API directamente

### 13. `lib/features/auth/presentation/widgets/login_form.dart`
- Label "Correo electrónico" → "Boleta"
- Quitar `keyboardType: TextInputType.emailAddress`
- Quitar validación de `@`; validar solo no-vacío
- Icono: `Icons.badge_outlined` o `Icons.credit_card`

### 14. `lib/features/auth/presentation/widgets/register_form.dart`
- Agregar campo "Boleta" (identificador) después de "Nombre completo"
- Mantener: nombre, correo, contraseña, confirmar contraseña

### 15. `lib/features/auth/presentation/pages/home_page.dart`
- Mostrar `identificador` y `rol` del usuario autenticado debajo del email

### 16. Regeneración y verificación
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
dart format lib/
```

## Orden de ejecución

1. `pubspec.yaml` + `flutter pub get`
2. `api_constants.dart`, `dio_client.dart`, `main.dart` (capa core)
3. `login_request.dart`, `register_request.dart` (modelos de request)
4. `user.dart`, `user_model.dart` (entidad + modelo de datos)
5. `auth_repository.dart`, `auth_repository_impl.dart`, `auth_remote_datasource.dart` (capa de datos)
6. `auth_provider.dart` (provider/notifier)
7. `login_form.dart`, `register_form.dart`, `home_page.dart` (UI)
8. `build_runner` + `analyze` + `format`
