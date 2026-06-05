
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/usuario.dart';
import '../models/diseno.dart';
import '../models/color.dart';
import 'reserva_screen.dart';

class DetalleScreen extends StatefulWidget {
  final Diseno diseno;
  final Usuario usuario;

  const DetalleScreen({
    super.key,
    required this.diseno,
    required this.usuario,
  });

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  List<ColorDiseno> _colores = [];
  final _observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarColores();
  }

  Future<void> _cargarColores() async {
    final colores = await AppDatabase.instance
        .obtenerColoresPorDiseno(widget.diseno.id!);
    setState(() => _colores = colores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E8C),
        title: Text(
          widget.diseno.nombre,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Imagen o placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.spa,
                size: 80,
                color: Color(0xFFE91E8C),
              ),
            ),
            const SizedBox(height: 20),

            // Descripción
            Text(
              widget.diseno.descripcion ?? '',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Paleta de colores
            const Text(
              'Paleta de colores',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E8C),
              ),
            ),
            const SizedBox(height: 12),

            _colores.isEmpty
                ? const Text('Sin colores registrados')
                : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colores.map((c) {
                      final color = Color(
                        int.parse('FF${c.hexCode}', radix: 16),
                      );
                      return Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.nombre,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 24),

            // Observaciones
            const Text(
              'Observaciones adicionales',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E8C),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacionesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ej: quiero el diseño con más brillo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Botón reservar
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservaScreen(
                    diseno: widget.diseno,
                    usuario: widget.usuario,
                    observaciones: _observacionesController.text.trim(),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reservar cita 💅',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}