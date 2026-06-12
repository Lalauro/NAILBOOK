import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  Usuario? _usuarioActual;
  String? _error;
  bool _cargando = false;

  Usuario? get usuarioActual => _usuarioActual;
  String? get error => _error;
  bool get cargando => _cargando;

  Future<bool> login(String correo, String password) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    final usuario = await AppDatabase.instance.loginUsuario(
      correo.trim(),
      password.trim(),
    );

    if (usuario != null) {
      _usuarioActual = usuario;
      _cargando = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Correo o contraseña incorrectos';
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registrar(String nombre, String correo, String password) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final nuevo = Usuario(
        nombre: nombre.trim(),
        correo: correo.trim(),
        password: password.trim(),
      );
      await AppDatabase.instance.insertarUsuario(nuevo);
      _cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'El correo ya está registrado';
      _cargando = false;
      notifyListeners();
      return false;
    }
  }

  void cerrarSesion() {
    _usuarioActual = null;
    notifyListeners();
  }
}