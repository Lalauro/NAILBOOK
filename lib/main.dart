import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/catalogo_viewmodel.dart';
import 'viewmodels/cita_viewmodel.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CatalogoViewModel()),
        ChangeNotifierProvider(create: (_) => CitaViewModel()),
      ],
      child: MaterialApp(
        title: 'Nail Book',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFE57FA8),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}