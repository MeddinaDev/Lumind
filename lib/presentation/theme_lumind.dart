import 'package:flutter/material.dart';

class ThemeLumind {
  // Colores del Sistema de Diseño
  static const Color fondo = Color(0xFFF5F5F7);
  static const Color superficie = Color(0xFFFFFFFF);
  static const Color textoPrincipal = Color(0xFF1D1D1F);
  static const Color textoSecundario = Color(0xFF86868B);
  static const Color acento = Color(0xFF5B5FC7); // Índigo Zafiro

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: fondo,
      fontFamily: 'San Francisco',
     colorScheme: ColorScheme.fromSeed(
        seedColor: acento,
        surface: superficie,
      ),
      // Configuración global de textos para la app
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textoPrincipal, fontWeight: FontWeight.w200),
        titleLarge: TextStyle(color: textoPrincipal, fontWeight: FontWeight.w600, letterSpacing: 4.0),
        bodyLarge: TextStyle(color: textoPrincipal, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: textoSecundario, fontWeight: FontWeight.w400),
      ),
    );
  }
}