class Persona {
  String? nombre;
  String? apellido;
  String? correo;
  String? password;
  String? rol;
  final String cedula;

  Persona({
    this.nombre,
    this.apellido,
    this.correo,
    required this.cedula,
    this.rol,
    this.password,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      cedula: json['cedula'],
      rol: json['rol'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'Conductor{nombre: $nombre,apellido: $apellido,correo: $correo, cedula: $cedula}, rol: $rol , contraseña: $password';
  }
}
