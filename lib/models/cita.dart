
class Cita {
  final int? id;
  final int usuarioId;
  final int disenoId;
  final String fecha;
  final String hora;
  final String direccion;
  final String? observaciones;
  final String estado;

  Cita({
    this.id,
    required this.usuarioId,
    required this.disenoId,
    required this.fecha,
    required this.hora,
    required this.direccion,
    this.observaciones,
    this.estado = 'pendiente',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'usuario_id': usuarioId,
    'diseno_id': disenoId,
    'fecha': fecha,
    'hora': hora,
    'direccion': direccion,
    'observaciones': observaciones,
    'estado': estado,
  };

  factory Cita.fromMap(Map<String, dynamic> map) => Cita(
    id: map['id'],
    usuarioId: map['usuario_id'],
    disenoId: map['diseno_id'],
    fecha: map['fecha'],
    hora: map['hora'],
    direccion: map['direccion'],
    observaciones: map['observaciones'],
    estado: map['estado'] ?? 'pendiente',
  );
}