
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/usuario.dart';
import 'catalogo_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  bool _esRegistro = false;
  String? _error;

  Future<void> _login() async {
    final usuario = await AppDatabase.instance.loginUsuario(
      _correoController.text.trim(),
      _passwordController.text.trim(),
    );

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CatalogoScreen(usuario: usuario),
        ),
      );
    } else {
      setState(() => _error = 'Correo o contraseña incorrectos');
    }
  }

  Future<void> _registrar() async {
    try {
      final nuevo = Usuario(
        nombre: _nombreController.text.trim(),
        correo: _correoController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await AppDatabase.instance.insertarUsuario(nuevo);
      setState(() {
        _esRegistro = false;
        _error = 'Registro exitoso, inicia sesión';
      });
    } catch (e) {
      setState(() => _error = 'El correo ya está registrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Icon(Icons.spa, size: 64, color: Color(0xFFE91E8C)),
              const SizedBox(height: 8),
              const Text(
                'Nail Book',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E8C),
                ),
              ),
              const SizedBox(height: 32),

              if (_esRegistro)
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (_esRegistro) const SizedBox(height: 16),

              TextField(
                controller: _correoController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _esRegistro ? _registrar : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E8C),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  _esRegistro ? 'Registrarse' : 'Iniciar sesión',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () => setState(() {
                  _esRegistro = !_esRegistro;
                  _error = null;
                }),
                child: Text(
                  _esRegistro
                      ? '¿Ya tienes cuenta? Inicia sesión'
                      : '¿No tienes cuenta? Regístrate',
                  style: const TextStyle(color: Color(0xFFE91E8C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}