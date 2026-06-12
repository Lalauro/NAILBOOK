import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../viewmodels/catalogo_viewmodel.dart';
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
  final _observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final vm = context.read<CatalogoViewModel>();
      vm.resetearColor();
      vm.cargarColores(widget.diseno.id!);
    });
  }

  List<String> _imagenesUnas() {
  return [
    'https://i.imgur.com/c3Gp130.jpeg',
    'https://i.imgur.com/XptXNHy.jpeg',
    'https://i.imgur.com/CCBIfWu.jpeg',
    'https://i.imgur.com/p05BnMD.jpeg',
    'https://i.imgur.com/a4RxeFU.jpeg',
  ];
}

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatalogoViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE57FA8),
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

            // Carrusel de imágenes
            FlutterCarousel(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 1.0,
              ),
              items: _imagenesUnas().map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    url,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.pink.shade50,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE57FA8),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _placeholder(),
                  ),
                );
              }).toList(),
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
              'Selecciona un color',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE57FA8),
              ),
            ),
            const SizedBox(height: 12),

            vm.cargando
                ? const CircularProgressIndicator()
                : vm.colores.isEmpty
                    ? const Text('Sin colores registrados')
                    : Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        children: vm.colores.map((c) {
                          final color = Color(
                            int.parse('FF${c.hexCode}', radix: 16),
                          );
                          final seleccionado =
                              vm.colorSeleccionado?.nombre == c.nombre;

                          return GestureDetector(
                            onTap: () => vm.seleccionarColor(c),
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: seleccionado ? 56 : 48,
                                  height: seleccionado ? 56 : 48,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: seleccionado
                                          ? const Color(0xFFE57FA8)
                                          : Colors.grey.shade300,
                                      width: seleccionado ? 3 : 1,
                                    ),
                                    boxShadow: seleccionado
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFE57FA8)
                                                  .withOpacity(0.4),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: seleccionado
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  c.nombre,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: seleccionado
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: seleccionado
                                        ? const Color(0xFFE57FA8)
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
                color: Color(0xFFE57FA8),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacionesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ej: quiero el diseño  brillo...',
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
              onPressed: vm.colorSeleccionado == null
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReservaScreen(
                            diseno: widget.diseno,
                            usuario: widget.usuario,
                            observaciones: _observacionesController.text.trim(),
                            colorSeleccionado: vm.colorSeleccionado!,
                          ),
                        ),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE57FA8),
                disabledBackgroundColor: Colors.grey.shade300,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                vm.colorSeleccionado == null
                    ? 'Selecciona un color para continuar'
                    : 'Reservar con ${vm.colorSeleccionado!.nombre} 💅',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.pink.shade50,
      child: Icon(
        IconData(
          widget.diseno.icono ?? Icons.spa.codePoint,
          fontFamily: 'MaterialIcons',
        ),
        size: 80,
        color: const Color(0xFFE57FA8),
      ),
    );
  }
}