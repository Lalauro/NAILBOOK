class Diseno {
  final int? id;
  final String nombre;
  final String? descripcion;
  final String? imagenUrl;
  final int? icono; // ← agrega esto

  Diseno({
    this.id,
    required this.nombre,
    this.descripcion,
    this.imagenUrl,
    this.icono, // ← agrega esto
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'imagen_url': imagenUrl,
  };

  factory Diseno.fromMap(Map<String, dynamic> map) => Diseno(
    id: map['id'],
    nombre: map['nombre'],
    descripcion: map['descripcion'],
    imagenUrl: map['imagen_url'],
  );
}