
class ColorDiseno {
  final int? id;
  final int disenoId;
  final String nombre;
  final String hexCode;

  ColorDiseno({
    this.id,
    required this.disenoId,
    required this.nombre,
    required this.hexCode,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'diseno_id': disenoId,
    'nombre': nombre,
    'hex_code': hexCode,
  };

  factory ColorDiseno.fromMap(Map<String, dynamic> map) => ColorDiseno(
    id: map['id'],
    disenoId: map['diseno_id'],
    nombre: map['nombre'],
    hexCode: map['hex_code'],
  );
}