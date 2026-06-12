import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/cita.dart';

class CitaViewModel extends ChangeNotifier {
  List<Cita> _citas = [];
  bool _cargando = false;
  String? _error;
  bool _citaGuardada = false;

  List<Cita> get citas => _citas;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get citaGuardada => _citaGuardada;

  Future<bool> guardarCita(Cita cita) async {
    _cargando = true;
    _error = null;
    _citaGuardada = false;
    notifyListeners();

    try {
      await AppDatabase.instance.insertarCita(cita);
      _citaGuardada = true;
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al guardar la cita';
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> cargarCitas(int usuarioId) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _citas = await AppDatabase.instance.obtenerCitasPorUsuario(usuarioId);
    } catch (e) {
      _error = 'Error al cargar las citas';
    }

    _cargando = false;
    notifyListeners();
  }

  void resetear() {
    _citaGuardada = false;
    _error = null;
    notifyListeners();
  }
}