
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cita_viewmodel.dart';
import '../models/usuario.dart';
import '../models/diseno.dart';
import '../models/cita.dart';
import '../models/color.dart';
import 'confirmacion_screen.dart';

class ResumenScreen extends StatelessWidget {
  final Diseno diseno;
  final Usuario usuario;
  final ColorDiseno colorSeleccionado;
  final String fecha;
  final String hora;
  final String direccion;
  final String? observaciones;

  const ResumenScreen({
    super.key,
    required this.diseno,
    required this.usuario,
    required this.colorSeleccionado,
    required this.fecha,
    required this.hora,
    required this.direccion,
    this.observaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE57FA8),
        title: const Text(
          'Revisa tu cita',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Todo está correcto?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE57FA8),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Revisa los datos antes de confirmar tu cita.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

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
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(int.parse('FF${colorSeleccionado.hexCode}', radix: 16)),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Color', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            colorSeleccionado.nombre,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(height: 24),
                  _fila(Icons.calendar_today, 'Fecha', fecha),
                  const Divider(height: 24),
                  _fila(Icons.access_time, 'Hora', hora),
                  const Divider(height: 24),
                  _fila(Icons.location_on, 'Dirección', direccion),
                  if (observaciones != null && observaciones!.isNotEmpty) ...[
                    const Divider(height: 24),
                    _fila(Icons.note, 'Observaciones', observaciones!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botón confirmar
            ElevatedButton(
              onPressed: () async {
                final cita = Cita(
                  usuarioId: usuario.id!,
                  disenoId: diseno.id!,
                  fecha: fecha,
                  hora: hora,
                  direccion: direccion,
                  observaciones: observaciones,
                );

                final ok = await context.read<CitaViewModel>().guardarCita(cita);

                if (ok && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmacionScreen(
                        cita: cita,
                        diseno: diseno,
                        usuario: usuario,
                        colorSeleccionado: colorSeleccionado,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE57FA8),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirmar cita 💅',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),

            // Botón editar
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE57FA8)),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Editar datos',
                style: TextStyle(color: Color(0xFFE57FA8), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, color: const Color(0xFFE57FA8), size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(
              valor,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}