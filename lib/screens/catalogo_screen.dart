
import 'package:flutter/material.dart';
import 'package:nailbook/models/color.dart';
import '../database/app_database.dart';
import '../models/usuario.dart';
import '../models/diseno.dart';
import 'detalle_screen.dart';
import 'login_screen.dart';

class CatalogoScreen extends StatefulWidget {
  final Usuario usuario;
  const CatalogoScreen({super.key, required this.usuario});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  List<Diseno> _disenos = [];

  @override
  void initState() {
    super.initState();
    _cargarDisenos();
  }

  Future<void> _cargarDisenos() async {
    final lista = await AppDatabase.instance.obtenerDisenos();

    // Si no hay diseños, inserta datos de prueba
    if (lista.isEmpty) {
      await _insertarDatosPrueba();
      final nueva = await AppDatabase.instance.obtenerDisenos();
      setState(() => _disenos = nueva);
    } else {
      setState(() => _disenos = lista);
    }
  }

  Future<void> _insertarDatosPrueba() async {
    final disenos = [
      Diseno(nombre: 'French Clásico', descripcion: 'Diseño atemporal en blanco y nude', imagenUrl: null),
      Diseno(nombre: 'Ombre Rosa', descripcion: 'Degradado suave en tonos rosados', imagenUrl: null),
      Diseno(nombre: 'Glitter Dorado', descripcion: 'Brillos dorados para ocasiones especiales', imagenUrl: null),
      Diseno(nombre: 'Floral Primavera', descripcion: 'Flores delicadas pintadas a mano', imagenUrl: null),
    ];

    for (final d in disenos) {
      final id = await AppDatabase.instance.insertarDiseno(d);
      // Insertar colores de prueba por diseño
      if (d.nombre == 'French Clásico') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Nude', hexCode: 'F5CBA7'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Blanco', hexCode: 'FFFFFF'));
      } else if (d.nombre == 'Ombre Rosa') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Claro', hexCode: 'FFB6C1'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Fucsia', hexCode: 'E91E8C'));
      } else if (d.nombre == 'Glitter Dorado') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Dorado', hexCode: 'FFD700'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Champagne', hexCode: 'F7E7CE'));
      } else if (d.nombre == 'Floral Primavera') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Lila', hexCode: 'C8A2C8'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Verde Menta', hexCode: '98FF98'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E8C),
        title: Text(
          'Hola, ${widget.usuario.nombre} 💅',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          )
        ],
      ),
      body: _disenos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _disenos.length,
                itemBuilder: (context, index) {
                  final diseno = _disenos[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalleScreen(
                          diseno: diseno,
                          usuario: widget.usuario,
                        ),
                      ),
                    ),
                    child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.spa, size: 48, color: Color(0xFFE91E8C)),
                          const SizedBox(height: 12),
                          Text(
                            diseno.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              diseno.descripcion ?? '',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

