import '../../features/auth/domain/entities/user.dart';

const String kRoleAdmin = 'admin';
const String kRoleAdministrativo = 'administrativo';
const String kRoleAlumno = 'alumno';

extension UserRoleX on User {
  bool get isAdmin => rol == kRoleAdmin || rol == kRoleAdministrativo;

  bool get isStudent => rol == kRoleAlumno;
}

extension StringRoleX on String {
  bool get isAdminRole => this == kRoleAdmin || this == kRoleAdministrativo;

  bool get isStudentRole => this == kRoleAlumno;
}
