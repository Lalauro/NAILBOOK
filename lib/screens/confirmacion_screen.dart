
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/diseno.dart';
import '../models/cita.dart';
import 'catalogo_screen.dart';

class ConfirmacionScreen extends StatelessWidget {
  final Cita cita;
  final Diseno diseno;
  final Usuario usuario;

  const ConfirmacionScreen({
    super.key,
    required this.cita,
    required this.diseno,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Icono de éxito
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE91E8C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                '¡Cita confirmada!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E8C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu reserva fue registrada exitosamente',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Tarjeta resumen
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _fila(Icons.person, 'Clienta', usuario.nombre),
                    const Divider(height: 24),
                    _fila(Icons.spa, 'Diseño', diseno.nombre),
                    const Divider(height: 24),
                    _fila(Icons.calendar_today, 'Fecha', cita.fecha),
                    const Divider(height: 24),
                    _fila(Icons.access_time, 'Hora', cita.hora),
                    const Divider(height: 24),
                    _fila(Icons.location_on, 'Dirección', cita.direccion),
                    if (cita.observaciones != null &&
                        cita.observaciones!.isNotEmpty) ...[
                      const Divider(height: 24),
                      _fila(Icons.note, 'Observaciones', cita.observaciones!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botón volver al catálogo
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CatalogoScreen(usuario: usuario),
                  ),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E8C),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Volver al catálogo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fila(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, color: const Color(0xFFE91E8C), size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}