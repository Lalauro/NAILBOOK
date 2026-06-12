import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/diseno.dart';
import '../models/color.dart';

class CatalogoViewModel extends ChangeNotifier {
  List<Diseno> _disenos = [];
  List<ColorDiseno> _colores = [];
  ColorDiseno? _colorSeleccionado;
  bool _cargando = false;
  String? _error;

  List<Diseno> get disenos => _disenos;
  List<ColorDiseno> get colores => _colores;
  ColorDiseno? get colorSeleccionado => _colorSeleccionado;
  bool get cargando => _cargando;
  String? get error => _error;

  void seleccionarColor(ColorDiseno color) {
    _colorSeleccionado = color;
    notifyListeners();
  }

  void resetearColor() {
    _colorSeleccionado = null;
    notifyListeners();
  }

  Future<void> cargarDisenos() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final lista = await AppDatabase.instance.obtenerDisenos();
      if (lista.isEmpty) {
        await _insertarDatosPrueba();
        _disenos = await AppDatabase.instance.obtenerDisenos();
      } else {
        _disenos = lista;
      }
    } catch (e) {
      _error = 'Error al cargar los diseños';
    }

    _cargando = false;
    notifyListeners();
  }

  Future<void> cargarColores(int disenoId) async {
    _cargando = true;
    notifyListeners();

    try {
      _colores = await AppDatabase.instance.obtenerColoresPorDiseno(disenoId);
    } catch (e) {
      _error = 'Error al cargar los colores';
    }

    _cargando = false;
    notifyListeners();
  }

  Future<void> _insertarDatosPrueba() async {
    final disenos = [
      Diseno(nombre: 'French Clásico', descripcion: 'Diseño atemporal en blanco y nude', icono: Icons.back_hand.codePoint),
      Diseno(nombre: 'Diseños de temporada', descripcion: 'Degradado suave en tonos rosados', icono: Icons.colorize.codePoint),
      Diseno(nombre: 'Glitter y más', descripcion: 'Brillos dorados para ocasiones especiales', icono: Icons.auto_awesome.codePoint),
      Diseno(nombre: 'Floral Primavera', descripcion: 'Flores delicadas pintadas a mano', icono: Icons.local_florist.codePoint),
      Diseno(nombre: 'Pedicura', descripcion: 'Cuidado y diseño para tus pies', icono: Icons.spa.codePoint),
      Diseno(nombre: 'Pasteles', descripcion: 'Tonos suaves y delicados', icono: Icons.palette.codePoint),
      Diseno(nombre: 'Uñas de Gel', descripcion: 'Larga duración con acabado brillante', icono: Icons.diamond.codePoint),
      Diseno(nombre: 'Nail Art', descripcion: 'Diseños creativos y personalizados', icono: Icons.brush.codePoint),
      Diseno(nombre: 'Acrílicas', descripcion: 'Extensiones resistentes y elegantes', icono: Icons.star.codePoint),
      Diseno(nombre: 'Degradado', descripcion: 'Transición suave entre dos colores', icono: Icons.gradient.codePoint),
    ];

    for (final d in disenos) {
      final id = await AppDatabase.instance.insertarDiseno(d);

      if (d.nombre == 'French Clásico') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Nude', hexCode: 'F5CBA7'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Blanco', hexCode: 'FFFFFF'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Pálido', hexCode: 'FFD1DC'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Beige', hexCode: 'F5F0EB'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Crema', hexCode: 'FFFDD0'));
      } else if (d.nombre == 'Diseños de temporada') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Claro', hexCode: 'FFB6C1'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Fucsia', hexCode: 'E57FA8'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Lila', hexCode: 'C8A2C8'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Melocotón', hexCode: 'FFCBA4'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Coral', hexCode: 'FF7F50'));
      } else if (d.nombre == 'Glitter y más') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Dorado', hexCode: 'FFD700'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Champagne', hexCode: 'F7E7CE'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Plateado', hexCode: 'C0C0C0'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Gold', hexCode: 'B76E79'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Bronce', hexCode: 'CD7F32'));
      } else if (d.nombre == 'Floral Primavera') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Lila', hexCode: 'C8A2C8'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Verde Menta', hexCode: '98FF98'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Floral', hexCode: 'FFB7C5'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Amarillo Suave', hexCode: 'FAFAD2'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Celeste', hexCode: 'B0E0E6'));
      } else if (d.nombre == 'Pedicura') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Coral', hexCode: 'FF7F50'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Azul Marino', hexCode: '000080'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rojo Clásico', hexCode: 'FF0000'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Nude', hexCode: 'F5CBA7'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Turquesa', hexCode: '40E0D0'));
      } else if (d.nombre == 'Pasteles') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Amarillo Pastel', hexCode: 'FFFFE0'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Azul Pastel', hexCode: 'AEC6CF'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Verde Pastel', hexCode: 'B5EAD7'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Lila Pastel', hexCode: 'E6DEFF'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Pastel', hexCode: 'FFD1DC'));
      } else if (d.nombre == 'Uñas de Gel') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Chicle', hexCode: 'FF69B4'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rojo Cereza', hexCode: 'DC143C'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Nude Rosado', hexCode: 'F4C2C2'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Blanco Perla', hexCode: 'F8F0E3'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Negro', hexCode: '1C1C1C'));
      } else if (d.nombre == 'Nail Art') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Azul Eléctrico', hexCode: '0000FF'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Verde Neón', hexCode: '39FF14'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Morado', hexCode: '800080'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Naranja', hexCode: 'FF6600'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Fucsia', hexCode: 'FF00FF'));
      } else if (d.nombre == 'Acrílicas') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Nude Natural', hexCode: 'E8C9A0'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Blanco', hexCode: 'FFFFFF'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa Bebé', hexCode: 'FFB6C1'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Dorado', hexCode: 'FFD700'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Plateado', hexCode: 'C0C0C0'));
      } else if (d.nombre == 'Degradado') {
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Rosa a Blanco', hexCode: 'FFB6C1'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Lila a Rosa', hexCode: 'C8A2C8'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Azul a Celeste', hexCode: 'ADD8E6'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Nude a Dorado', hexCode: 'F5CBA7'));
        await AppDatabase.instance.insertarColor(ColorDiseno(disenoId: id, nombre: 'Negro a Gris', hexCode: '4A4A4A'));
}
    }
  }
}