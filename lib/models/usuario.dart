
class Usuario {
  final int? id;
  final String nombre;
  final String correo;
  final String password;
  final String? direccionDefault;

  Usuario({
    this.id,
    required this.nombre,
    required this.correo,
    required this.password,
    this.direccionDefault,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'password': password,
    'direccion_default': direccionDefault,
  };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id'],
    nombre: map['nombre'],
    correo: map['correo'],
    password: map['password'],
    direccionDefault: map['direccion_default'],
  );
}