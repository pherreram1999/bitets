class LoginRequest {
  final String identificador;
  final String password;
  final String deviceName;

  const LoginRequest({
    required this.identificador,
    required this.password,
    required this.deviceName,
  });

  Map<String, dynamic> toJson() => {
    'identificador': identificador,
    'password': password,
    'device_name': deviceName,
  };
}
