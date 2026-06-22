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

Shared code lives in `lib/core/` (theme, router, constants, utils, network).

### State management

Use **Riverpod** (`flutter_riverpod` + `riverpod_annotation`). Prefer `@riverpod` code-gen. Wrap `runApp` with `ProviderScope`. Use `AsyncNotifier` for async state, `Notifier` for sync.

### UI

**Material 3** always. Set `useMaterial3: true` in `ThemeData`. Never use M2-only APIs (`FloatingActionButtonThemeData.sizeConstraints` etc). Use `ColorScheme.fromSeed`.

### API endpoint

The backend base URL is resolved in `lib/main.dart::_resolveEndpoint()`, which returns the production endpoint `https://saets.nullpointer.us.kg/api/v1`. `main()` calls `DioClient.updateBaseUrl(...)` with that value before `runApp`, which syncs `ApiConstants.baseUrl` and the singleton `Dio` instance's `options.baseUrl`. There is no `--dart-define` override anymore — to switch to a local backend, edit `_resolveEndpoint()` (or `ApiConstants.baseUrl` directly). The `DioClient` singleton adds the `AuthInterceptor` once (in `Auth.build()`). All HTTP features must go through `DioClient.instance` and never re-register the interceptor. Per-resource endpoint paths live in `LaravelResourceController(basePath)` (e.g. `'/areas'`, `'/profesores'`), NOT inline in datasources.

## Working with grids (catalogos)

The repo ships a reusable CRUD grid in `lib/features/grid/` that drives every catalog page in the admin panel (Areas, Profesores, Carreras, etc.). It is built on top of Laravel's resource controllers and assumes a fixed API contract. This section is the full reference for using and extending it.

### 1. What the grid gives you for free

When you extend `GridPage<T>`, the base `GridState<T>` (in `lib/features/grid/presentation/pages/grid_state.dart`) wires up:

| Feature | How it works |
|---|---|
| **Paginated list** | Reads the page number from internal state, watches the provider, renders cards. A `_PaginationBar` at the bottom with chevron prev/next and "Pagina X de Y" controls `_currentPage`. |
| **Card layout** | Each item renders inside a `Card` with the body the concrete page provides + a `PopupMenuButton` (`more_vert` icon) on the right with the actions list. |
| **Pull-to-refresh** | The list is wrapped in `RefreshIndicator` with `AlwaysScrollableScrollPhysics` so it works even with 0 items. The callback calls `widget.refresh(ref, _currentPage)` which must await the provider's `.future` so the spinner stays visible. |
| **Confirmation modal** | Before running any action with `requiresConfirmation == true`, the state shows a Material `AlertDialog` (title = action label, content = `confirmationMessage` or default "Estas seguro?", actions = Cancelar / FilledButton). |
| **Loading / error states** | `state.when(loading, error, data)` renders a centered spinner, a red error message, or the data view (or "Sin resultados" if `items.isEmpty`). |
| **Refresh after mutation** | After an action returns `true`, the state calls `widget.onActionCompleted(ref)`, which must invalidate the provider. |
| **Submit + error display** | The form's save button POSTs or PUTs via `DioClient.instance`. On 4xx/5xx, the error message from the response (or a generic fallback) is rendered inside an `errorContainer`. |

The base **never** knows your catalog's model, fields, or URL. You provide all of it.

### 2. Concepts and file layout

```
lib/features/grid/                                # infrastructure (do not edit for a new catalog)
  domain/entities/
    has_id.dart                                   # abstract HasId { String get id; }
    paginated_result.dart                         # PaginatedResult<T extends HasId>
    laravel_resource_controller.dart              # URL builder for a Laravel resource
    grid_action.dart                              # abstract GridAction<T> + GridFormBuilder<T> typedef
  data/
    models/laravel_paginated_response.dart        # @JsonSerializable for the list response
    datasources/laravel_grid_datasource.dart      # Dio calls, unwraps {"data": {...}} for single items
    repositories/grid_repository_impl.dart        # generic CRUD implementation
  presentation/
    pages/
      grid_page.dart                              # abstract ConsumerStatefulWidget
      grid_state.dart                             # base State: paginator, popup menu, confirmations, RefreshIndicator
    providers/grid_base_notifier.dart             # GridNotifierOps (static helpers for refresh / delete-and-refresh)
    actions/                                      # the 3 default action classes
      view_action.dart
      edit_action.dart
      delete_action.dart
    forms/
      grid_form.dart                              # abstract ConsumerStatefulWidget
      grid_form_state.dart                        # base State: submit, error, hydrate, etc.
```

A concrete catalog adds **5 files** under `lib/features/<name>/` and nothing else. No new dependencies, no new packages, no edits to the router.

### 3. Concepts in detail

#### `HasId`
The base contract for any item the grid can render. Forces the model to expose a String id (the API returns int; conversion happens in `fromJson`).
```dart
abstract class HasId { String get id; }
```

#### `LaravelResourceController`
Immutable value object that builds URLs for a Laravel resource controller given a base path:

| Method | Returns | Maps to |
|---|---|---|
| `list({int? page})` | `'/foos'` or `'/foos?page=2'` | `GET /foos[?page=N]` |
| `show(String id)` | `'/foos/42'` | `GET /foos/42` |
| `create()` | `'/foos'` | `POST /foos` |
| `update(String id)` | `'/foos/42'` | `PUT /foos/42` |
| `delete(String id)` | `'/foos/42'` | `DELETE /foos/42` |

Pass one of these to the `LaravelGridDatasource` constructor and to any action that needs to build an endpoint.

#### `PaginatedResult<T>`
```dart
class PaginatedResult<T extends HasId> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  bool get hasNextPage;
  bool get hasPreviousPage;
}
```
Read directly from `LaravelPaginatedResponse.meta.current_page` / `last_page` / `total`. The repository's `fetchPage` builds it from the response.

#### `GridAction<T>` and the typedef `GridFormBuilder<T>`
```dart
typedef GridFormBuilder<T> = Widget Function({
  required String endpoint,
  T? item,
  bool readOnly,
});
```
`GridAction` is the abstract base for any action you can put in the 3-dots menu. Each one is a class (not a lambda) with:
- `String get label` — shown in the menu and in confirmation dialogs.
- `IconData get icon` — shown in the menu.
- `bool get requiresConfirmation` (default `false`) — if true, the state shows an `AlertDialog` before invoking.
- `String? get confirmationMessage` (default `null` → generic "Estas seguro?").
- `Future<bool> execute(context, item, repository, controller, formBuilder)` — does the work. Returns `true` if the grid should refresh, `false` otherwise.

The three default actions (`ViewAction`, `EditAction`, `DeleteAction`) cover the standard CRUD. Custom catalogs can add more by implementing `GridAction<T>` (e.g. `RestoreAction<T>` for soft-deletes, see section 8).

#### `GridRepository<T>` and `GridRepositoryImpl<T>`
The interface and default implementation. The interface is:

```dart
abstract class GridRepository<T extends HasId> {
  Future<PaginatedResult<T>> fetchPage(int page);
  Future<T> getOne(String id);
  Future<T> create(Map<String, dynamic> data);
  Future<T> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
  T fromJson(Map<String, dynamic> json);   // must be overridden by the concrete repo
}
```

The base `GridRepositoryImpl<T>` implements all of them by delegating to a `LaravelGridDatasource` and using the concrete `fromJson`. A concrete catalog extends it and only provides the controller and the `fromJson` override.

#### `GridNotifierOps` (static helpers)
Located in `lib/features/grid/presentation/providers/grid_base_notifier.dart`. Pure functions that take a `GridRepository<T>` and a page number, returning `Future<PaginatedResult<T>>`:

- `GridNotifierOps.refreshPage(repo, page)` — fetch one page.
- `GridNotifierOps.deleteAndRefresh(repo, page, id)` — delete, then fetch the same page.

These exist because Riverpod 3.x with `@riverpod` code-gen doesn't expose a public mixable base class (the underlying `AutoDisposeFamilyAsyncNotifier` is no longer in the public API). Using the static helpers keeps each concrete notifier at ~10 lines.

### 4. The 5-file recipe for a new catalog

Let's wire up a hypothetical `Foo` catalog backed by `/foos`. The steps are mechanical — just copy each snippet and replace `Foo` / `foos` with the real name.

#### 4.1 Entity — `lib/features/foo/domain/entities/foo.dart`

Extend `HasId`. Convert the API's int id to String. Tolerate nulls in any field that the backend may not return (use `as T? ?? defaultValue`):

```dart
import '../../../grid/domain/entities/has_id.dart';

class Foo extends HasId {
  const Foo({
    required this.id,
    required this.nombre,
    required this.clave,
    this.observaciones,
  });

  @override
  final String id;
  final String nombre;
  final String clave;
  final String? observaciones;

  factory Foo.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Foo(
      id: rawId is int ? rawId.toString() : (rawId as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      clave: (json['clave'] as String?) ?? '',
      observaciones: json['observaciones'] as String?,
    );
  }
}
```

#### 4.2 Repository — `lib/features/foo/data/repositories/foo_repository.dart`

Plug the base path and delegate `fromJson`. **Do not** add HTTP code here — it lives in `LaravelGridDatasource`.

```dart
import '../../../grid/data/repositories/grid_repository_impl.dart';
import '../../../grid/domain/entities/laravel_resource_controller.dart';
import '../../domain/entities/foo.dart';

class FooRepository extends GridRepositoryImpl<Foo> {
  FooRepository()
    : super(controller: const LaravelResourceController('/foos'));

  @override
  Foo fromJson(Map<String, dynamic> json) => Foo.fromJson(json);
}
```

#### 4.3 Providers — `lib/features/foo/presentation/providers/foo_providers.dart`

Two providers: a `Provider<FooRepository>` (instantiated once and shared) and a `@riverpod` notifier keyed by `int page`. **Note**: in Riverpod 3.x, the family argument is exposed as a generated getter called `page` (named after the `build` parameter), **not** as `arg` (which was the 2.x API).

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../grid/domain/entities/paginated_result.dart';
import '../../../grid/presentation/providers/grid_base_notifier.dart';
import '../../data/repositories/foo_repository.dart';
import '../../domain/entities/foo.dart';

part 'foo_providers.g.dart';

final fooRepositoryProvider = Provider<FooRepository>(
  (ref) => FooRepository(),
);

@riverpod
class FooGrid extends _$FooGrid {
  @override
  Future<PaginatedResult<Foo>> build(int page) =>
      GridNotifierOps.refreshPage(ref.read(fooRepositoryProvider), page);

  Future<void> deleteItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => GridNotifierOps.deleteAndRefresh(
          ref.read(fooRepositoryProvider),
          page,
          id,
        ));
  }
}
```

Run `dart run build_runner build --delete-conflicting-outputs` to generate `foo_providers.g.dart` and commit it.

#### 4.4 Form — `lib/features/foo/presentation/forms/foo_form.dart`

The form has the most ownership. The state extends `GridFormState<T>` which is a `ConsumerState<GridForm<T>>` — `ref` is available for reading other providers (e.g. for a dropdown of a related catalog). You only own the field widgets and the data map; the base provides the AppBar save button, the loading spinner, the error display, the POST/PUT plumbing, and the `Navigator.pop(true)` on success.

Four overrides are required:

| Method | Purpose |
|---|---|
| `String get formTitle` | Shown in the AppBar. Usually `"Nuevo <thing>"` for create, `"Editar <thing>"` for update. |
| `void hydrate(T? item)` | Called from `initState`. Populate your `TextEditingController`s and any other state from `item` (or default empty). |
| `Widget buildFormFields(context, T? item)` | Return the body widgets (TextFields, DropdownButtonFormField, etc.). Honor `widget.readOnly` by passing `onChanged: null` to inputs, or by wrapping the whole thing in `AbsorbPointer(absorbing: widget.readOnly)`. |
| `Map<String, dynamic> collectFormData()` | Return the JSON body for the request. **MUST** distinguish create vs update: in create, send all fields; in update, omit empty strings so the backend's `sometimes` validation doesn't overwrite fields with `""`. |

Also override `dispose()` to dispose any `TextEditingController`s you created.

```dart
class FooForm extends GridForm<Foo> {
  const FooForm({
    super.key,
    required super.endpoint,
    super.item,
    super.readOnly = false,
  });

  @override
  ConsumerState<GridForm<Foo>> createState() => _FooFormState();
}

class _FooFormState extends GridFormState<Foo> {
  final _nombreController = TextEditingController();
  final _claveController = TextEditingController();
  final _observacionesController = TextEditingController();

  @override
  String get formTitle => widget.item == null ? 'Nuevo foo' : 'Editar foo';

  @override
  void hydrate(Foo? item) {
    _nombreController.text = item?.nombre ?? '';
    _claveController.text = item?.clave ?? '';
    _observacionesController.text = item?.observaciones ?? '';
  }

  @override
  Widget buildFormFields(BuildContext context, Foo? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _claveController,
          decoration: const InputDecoration(
            labelText: 'Clave',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _observacionesController,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> collectFormData() {
    final nombre = _nombreController.text.trim();
    final clave = _claveController.text.trim();
    final observaciones = _observacionesController.text.trim();
    if (widget.item == null) {
      return {
        'nombre': nombre,
        'clave': clave,
        if (observaciones.isNotEmpty) 'observaciones': observaciones,
      };
    }
    return {
      if (nombre.isNotEmpty) 'nombre': nombre,
      if (clave.isNotEmpty) 'clave': clave,
      if (observaciones.isNotEmpty) 'observaciones': observaciones,
    };
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _claveController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
```

If the form needs a dropdown of a related catalog, expose a `FutureProvider<List<...>>` (e.g. `areasListProvider` in `lib/features/areas/presentation/providers/areas_providers.dart`) and read it with `ref.watch(...)` inside `buildFormFields`. The first page is usually enough for short lists; a richer paginated selector can be added later. Concrete example: `lib/features/profesores/presentation/forms/profesor_form.dart` (dropdown of areas).

#### 4.5 Page — `lib/features/foo/presentation/pages/foo_grid_page.dart`

The page is mostly glue. Eight overrides:

| Override | Purpose |
|---|---|
| `String get title` | AppBar title (and Drawer label, if used). |
| `GridRepository<T> get repository` | Instance for the actions to call (e.g. `DeleteAction` uses `repository.delete`). |
| `LaravelResourceController get controller` | Used by `EditAction` and `DeleteAction` to build URLs. |
| `List<GridAction<T>> get actions` | The actions that appear in the 3-dots menu. Order matters: that's the order they're shown. |
| `GridFormBuilder<T> get formBuilder` | Factory the actions call to instantiate the form widget. |
| `AsyncValue<PaginatedResult<T>> watchGrid(ref, page)` | Hook for the page to declare which provider to watch. Usually just `ref.watch(fooGridProvider(page))`. |
| `void onActionCompleted(ref)` | Called after a successful action. Almost always `ref.invalidate(fooGridProvider)`. |
| `Future<void> refresh(ref, page)` | Called by `RefreshIndicator`. The `await ref.read(fooGridProvider(page).future)` is essential — without it, the `invalidate` returns synchronously and the spinner dismisses before the network call completes. |
| `Widget buildCardBody(context, item)` | The body of each card. Style it however you want, but keep it under ~3 lines of text so the card stays compact. |

```dart
class FooGridPage extends GridPage<Foo> {
  const FooGridPage({super.key});

  @override String get title => 'Foos';
  @override GridRepository<Foo> get repository => FooRepository();
  @override LaravelResourceController get controller =>
      const LaravelResourceController('/foos');
  @override List<GridAction<Foo>> get actions => const [
        ViewAction<Foo>(), EditAction<Foo>(), DeleteAction<Foo>(),
      ];
  @override GridFormBuilder<Foo> get formBuilder =>
      ({required endpoint, item, readOnly = false}) =>
          FooForm(endpoint: endpoint, item: item, readOnly: readOnly);

  @override AsyncValue<PaginatedResult<Foo>> watchGrid(WidgetRef ref, int page) =>
      ref.watch(fooGridProvider(page));
  @override void onActionCompleted(WidgetRef ref) => ref.invalidate(fooGridProvider);
  @override Future<void> refresh(WidgetRef ref, int page) async {
    ref.invalidate(fooGridProvider);
    await ref.read(fooGridProvider(page).future);
  }

  @override
  Widget buildCardBody(BuildContext context, Foo item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.nombre, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(item.clave,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }
}
```

### 5. Wiring the page into the admin panel

The admin uses a `Drawer` (not a `NavigationBar`) in `lib/features/admin/presentation/pages/admin_home_page.dart`. To add a new catalog:

1. Add the new destination to `_destinations` (with a Material icon) and the page to `_pages`, keeping the indices aligned.
2. That's it — the `Drawer` already handles the navigation; no router changes.

For example, after adding the `Foo` files above, the admin home page becomes:

```dart
import '../../../foo/presentation/pages/foo_grid_page.dart';
// ...
static const List<Widget> _pages = [
  AdminDashboardPage(),
  AdminReportsPage(),
  AreasGridPage(),
  ProfesoresGridPage(),
  FooGridPage(),
];

static const List<_AdminDestination> _destinations = [
  // ...existing entries...
  _AdminDestination(
    icon: Icons.category_outlined,
    selectedIcon: Icons.category,
    label: 'Foos',
  ),
];
```

### 6. Lifecycle of every flow

The base `GridState` and `GridFormState` coordinate these flows; understanding them is the difference between "the grid works" and "I can debug when it doesn't".

#### Read (page load)
```
GridState.build()
  -> widget.watchGrid(ref, _currentPage)     // ref.watch(fooGridProvider(page))
  -> provider build runs GridNotifierOps.refreshPage(repo, page)
  -> repo.fetchPage(page) -> datasource.fetchPage(page)
  -> Dio GET /foos?page=N
  -> response.data parsed by LaravelPaginatedResponse
  -> each item passed to repo.fromJson -> Foo
  -> PaginatedResult<Foo> returned
  -> state.when(loading/error/data) renders the list
```

#### Pagination
```
User taps chevron_right
  -> _goToPage(currentPage + 1) -> setState(_currentPage = ...)
  -> GridState.build() re-runs
  -> widget.watchGrid(ref, _currentPage) reads the new arg
  -> ref.watch with new arg either finds an existing entry or creates one
  -> first call after page change: new entry, fetch runs; subsequent: cached
  -> Use the paginator's _currentPage as the single source of truth
```

#### Pull-to-refresh
```
User pulls down
  -> RefreshIndicator.onRefresh fires
  -> widget.refresh(ref, _currentPage) is called
  -> ref.invalidate(fooGridProvider)        // mark for rebuild
  -> await ref.read(fooGridProvider(page).future)  // wait for new state
  -> spinner dismisses, list updates
```

#### Create
`CreateAction<T>` (`lib/features/grid/presentation/actions/create_action.dart`) is exposed via the optional `GridAction<T>? get createAction => null;` getter on `GridPage`, NOT via the `actions` list. `GridState` renders an `IconButton(Icons.add)` in the `AppBar` when `widget.createAction != null && _isAdmin(ref)`, and calls `_runAction(createAction, null)`. Because it lives outside `actions`, it never appears in the per-row popup menu (which would pass a non-null `item` and trip `CreateAction`'s `ArgumentError`). Admin grids override `createAction => const CreateAction<T>()`; the two `alumno_*` grids leave the default `null`.
  -> formBuilder(endpoint: controller.create(), item: null, readOnly: false)
  -> returns true -> widget.onActionCompleted(ref) -> ref.invalidate(fooGridProvider)
  -> provider rebuilds, grid refreshes
```

#### Edit (3-dots)
```
User taps menu -> Editar
  -> _confirmAction (no, EditAction doesn't require confirmation)
  -> _runAction(EditAction, item)
  -> editAction.execute(context, item, repo, controller, formBuilder)
     -> Navigator.push(formBuilder(endpoint: controller.update(item.id), item, readOnly: false))
     -> hydrate(item) -> controllers pre-filled
     -> user edits, taps Guardar -> _submit()
        -> widget.item != null -> _dio.put(endpoint, data: collectFormData())
        -> 2xx -> Navigator.pop(context, true)
  -> action returns true
  -> state calls onActionCompleted -> refresh
```

#### View (3-dots, read-only)
```
User taps menu -> Visualizar
  -> _runAction(ViewAction, item)
  -> viewAction.execute(context, item, repo, controller, formBuilder)
     -> Navigator.push(formBuilder(endpoint: controller.show(item.id), item, readOnly: true))
     -> hydrate(item) -> controllers pre-filled
     -> AppBar has NO Guardar button (form hides it when readOnly)
     -> form body wrapped in AbsorbPointer(absorbing: true) via buildFormFields
     -> user dismisses (back button) -> Navigator.pop(context, false) (implicit null)
  -> action returns false (result ?? false)
  -> state does NOT call onActionCompleted -> no refresh (nothing changed)
```

#### Delete (3-dots, with confirmation)
```
User taps menu -> Eliminar
  -> _confirmAction(deleteAction) shows AlertDialog
  -> user confirms
  -> _runAction(DeleteAction, item)
  -> deleteAction.execute(context, item, repo, controller, formBuilder)
     -> repo.delete(item.id) -> datasource.delete(id)
        -> Dio DELETE /foos/{id}
        -> 204 expected; body ignored
     -> return true
  -> state calls onActionCompleted -> refresh
```

### 7. API contract the grid assumes

The grid assumes the backend follows the standard Laravel `php artisan make:controller FooController --resource` + `Route::apiResource('foos', FooController::class)` shape. Specifically:

| Endpoint | Method | Returns | Body |
|---|---|---|---|
| `/foos?page=N` | GET | `{ data: Foo[], links: {...}, meta: { current_page, last_page, total, ... } }` | — |
| `/foos` | POST | `201 { data: Foo }` | JSON object matching `StoreFooRequest` |
| `/foos/{id}` | GET | `200 { data: Foo }` | — |
| `/foos/{id}` | PUT | `200 { data: Foo }` | JSON object (partial OK, fields are `sometimes` in validation) |
| `/foos/{id}` | DELETE | `204` (no body) | — |
| `/foos/{id}/restore` | POST | `200 { data: Foo }` | — (NOT exposed by the grid by default) |

The `data` envelope for single items is unwrapped by `LaravelGridDatasource._unwrapData` before `fromJson` sees it. If the backend ever stops sending the `{"data": ...}` envelope, you'll need to relax that helper.

### 8. Common customizations

#### Add a custom action (e.g., `RestoreAction<T>` for soft-deletes)
1. Create `lib/features/grid/presentation/actions/restore_action.dart` with a class implementing `GridAction<T extends HasId>`. Its `execute` calls `repository.restore(item.id)` and returns `true`. Optionally set `requiresConfirmation: true`.
2. Add `Future<void> restore(String id)` to `GridRepository<T>`, implement it in `GridRepositoryImpl<T>` (delegating to the datasource), and add `Future<void> restore(String id)` to `LaravelGridDatasource` calling `_dio.post(_controller.restore(id))`. Also add a `String restore(String id) => '$basePath/$id/restore';` to `LaravelResourceController`.
3. Add `RestoreAction<T>()` to the concrete page's `actions` list.

#### Show related data in the card body
Override `buildCardBody` to render whatever the model has. For example, if `Foo` had a `carreraId`, you could load the related `Carrera` via a `FutureProvider<Carrera?>` and display its name next to the id. The card body is plain `Widget` — it has access to `WidgetRef` if you make it a `ConsumerWidget`, but the simplest is to just render the `Foo` fields directly and let users click into Edit/View for the rest.

#### Custom form validation
Override the form's `buildFormFields` to wrap inputs in a `Form` with `TextFormField` (instead of bare `TextField`) and a `GlobalKey<FormState>`. In `collectFormData`, read the form's `currentState?.validate()` and throw or return early if false. The base's `_submit` catches errors and renders the message; if you want a more polished experience, override `_submit` (it's not `final`, just an instance method on `GridFormState`).

#### Search bar
Not built in. The cleanest place to add it: wrap the `Column` in `grid_state.dart` with a stateful widget that holds a search query, and pass the query to the provider via a `family` parameter (e.g. `fooGridProvider(page, query)`). This requires extending the notifier to accept `(int page, String query)`.

### 9. Conventions specific to grids

- Spanish for user-facing strings; English for code/identifiers. Match existing files.
- **No code comments** (per the project's global rule).
- `collectFormData` MUST distinguish create vs update. For create, send all fields. For update, omit empty strings so the backend's `sometimes` validation doesn't overwrite existing values with `""`.
- If a form needs a dropdown of another catalog, expose a `FutureProvider<List<...>>` and read it with `ref.watch(...)` inside `buildFormFields`. The first page is sufficient for most relationships; a richer selector can come later.
- `LaravelPaginatedResponse.data` is `List<dynamic>`; conversion to `T` happens in `GridRepositoryImpl.fetchPage` via the concrete `fromJson`. The single-resource endpoints are unwrapped by `LaravelGridDatasource._unwrapData` before the concrete `fromJson` sees them.
- The `restore` soft-delete endpoint is not exposed as a default action (see section 8 for how to add it).
- After editing any `@riverpod` or `@JsonSerializable` file, run `dart run build_runner build --delete-conflicting-outputs` and commit the `*.g.dart`.

### 10. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `type Null is not a subtype of type 'String' in type cast` at runtime when the grid loads | A field in your `fromJson` is `as String` (non-nullable) and the backend sent `null` for it. | Change to `(json['field'] as String?) ?? ''` (or `null` for genuinely optional fields). |
| `Undefined name 'arg'` in a `@riverpod` notifier | You're on Riverpod 3.x; `arg` was the 2.x name. | Use `page` (the generated getter named after the `build` parameter). |
| `ConsumerState` undefined in a form | Missing `import 'package:flutter_riverpod/flutter_riverpod.dart';` in the form file. | Add the import. |
| `AsyncValue.when` undefined | Same — `AsyncValue` is reexported by `flutter_riverpod`. | Add the import. |
| Spinner dismisses instantly on pull-to-refresh | `refresh` didn't `await` the provider's future. | Make sure `refresh` is `await ref.read(fooGridProvider(page).future);` after `invalidate`. |
| Server returns 422 on edit | You're sending fields the server doesn't know about (e.g. the API was updated and you didn't migrate your model), or sending empty strings where the server expects `sometimes`. | Update `fromJson` and the form to match the latest API spec. In `collectFormData`'s update branch, omit empty strings. |
| Server returns 401 unexpectedly | Token expired; `AuthInterceptor` should redirect to `/login` automatically. | If it doesn't, the action threw before the interceptor's onError ran — check that the request actually went through `DioClient.instance`. |
| `view` shows the save button | The form's `buildFormFields` ignores `widget.readOnly`. | Pass `readOnly: true` through your inputs (e.g. `TextField(readOnly: true)` or `onChanged: null` on `DropdownButtonFormField`), or wrap the body in `AbsorbPointer(absorbing: widget.readOnly)`. |

## Stack constraints

- Flutter **stable channel, v3.x**
- Dart SDK `^3.11.5`
- Target platforms: Android, iOS, Linux, macOS, Windows, Web
