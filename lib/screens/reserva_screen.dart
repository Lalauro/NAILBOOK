
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/usuario.dart';
import '../models/diseno.dart';
import '../models/cita.dart';
import 'confirmacion_screen.dart';

class ReservaScreen extends StatefulWidget {
  final Diseno diseno;
  final Usuario usuario;
  final String observaciones;

  const ReservaScreen({
    super.key,
    required this.diseno,
    required this.usuario,
    required this.observaciones,
  });

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  DateTime? _fechaSeleccionada;
  String? _horaSeleccionada;
  final _direccionController = TextEditingController();
  String? _error;

  final List<String> _horasDisponibles = [
    '09:00', '10:00', '11:00',
    '12:00', '14:00', '15:00',
    '16:00', '17:00'
  ];

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy.add(const Duration(days: 1)),
      firstDate: hoy.add(const Duration(days: 1)),
      lastDate: hoy.add(const Duration(days: 60)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFE91E8C),
          ),
        ),
        child: child!,
      ),
    );
    if (fecha != null) setState(() => _fechaSeleccionada = fecha);
  }

  Future<void> _confirmarCita() async {
    if (_fechaSeleccionada == null) {
      setState(() => _error = 'Selecciona una fecha');
      return;
    }
    if (_horaSeleccionada == null) {
      setState(() => _error = 'Selecciona una hora');
      return;
    }
    if (_direccionController.text.trim().isEmpty) {
      setState(() => _error = 'Ingresa una dirección');
      return;
    }

    final cita = Cita(
      usuarioId: widget.usuario.id!,
      disenoId: widget.diseno.id!,
      fecha: _fechaSeleccionada!.toIso8601String().substring(0, 10),
      hora: _horaSeleccionada!,
      direccion: _direccionController.text.trim(),
      observaciones: widget.observaciones.isEmpty
          ? null
          : widget.observaciones,
    );

    await AppDatabase.instance.insertarCita(cita);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmacionScreen(
          cita: cita,
          diseno: widget.diseno,
          usuario: widget.usuario,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E8C),
        title: const Text(
          'Reservar cita',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Diseño seleccionado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.1),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.spa, color: Color(0xFFE91E8C), size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diseño seleccionado',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        widget.diseno.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fecha
            const Text(
              'Fecha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFE91E8C),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _seleccionarFecha,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFFE91E8C)),
                    const SizedBox(width: 12),
                    Text(
                      _fechaSeleccionada == null
                          ? 'Seleccionar fecha'
                          : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                      style: TextStyle(
                        color: _fechaSeleccionada == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hora
            const Text(
              'Hora',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFE91E8C),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _horasDisponibles.map((hora) {
                final seleccionada = _horaSeleccionada == hora;
                return GestureDetector(
                  onTap: () => setState(() => _horaSeleccionada = hora),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: seleccionada
                          ? const Color(0xFFE91E8C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE91E8C),
                      ),
                    ),
                    child: Text(
                      hora,
                      style: TextStyle(
                        color: seleccionada ? Colors.white : const Color(0xFFE91E8C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Dirección
            const Text(
              'Dirección',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFE91E8C),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(
                hintText: 'Ej: Calle 123 # 45-67, Bogotá',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Color(0xFFE91E8C),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 24),

            // Botón confirmar
            ElevatedButton(
              onPressed: _confirmarCita,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirmar cita',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}