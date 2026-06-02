import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Estados posibles de la autenticacion.
@freezed
class AuthState with _$AuthState {
  /// Estado inicial, antes de verificar si hay sesion guardada.
  const factory AuthState.initial() = _Initial;

  /// Cargando (login, registro, verificacion de token).
  const factory AuthState.loading() = _Loading;

  /// Usuario autenticado correctamente.
  const factory AuthState.authenticated(User user) = _Authenticated;

  /// No autenticado. Opcionalmente incluye un mensaje de error.
  const factory AuthState.unauthenticated([String? message]) = _Unauthenticated;
}
