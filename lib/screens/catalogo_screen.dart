import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/catalogo_viewmodel.dart';
import '../models/usuario.dart';
import 'detalle_screen.dart';
import 'login_screen.dart';

class CatalogoScreen extends StatefulWidget {
  final Usuario usuario;
  const CatalogoScreen({super.key, required this.usuario});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CatalogoViewModel>().cargarDisenos());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatalogoViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE57FA8),
        title: Text(
          'Hola, ${widget.usuario.nombre} 💅',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthViewModel>().cerrarSesion();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text(vm.error!))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: vm.disenos.length,
                    itemBuilder: (context, index) {
                      final diseno = vm.disenos[index];
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
                              Icon(
                                IconData(
                                  diseno.icono ?? Icons.spa.codePoint,
                                  fontFamily: 'MaterialIcons',
                                ),
                                size: 48,
                                color: const Color(0xFFE57FA8),
                              ),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                  diseno.descripcion ?? '',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
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