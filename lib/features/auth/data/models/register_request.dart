class RegisterRequest {
  final String name;
  final String email;
  final String identificador;
  final String password;
  final String passwordConfirmation;
  final String rol;
  final String deviceName;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.identificador,
    required this.password,
    required this.passwordConfirmation,
    required this.deviceName,
    this.rol = 'alumno',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'identificador': identificador,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'rol': rol,
    'device_name': deviceName,
  };
}
