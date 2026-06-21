import 'package:flutter/material.dart';

void main() {
  runApp(const LumindApp());
}

class LumindApp extends StatelessWidget {
  const LumindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumind',
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "Debug" arriba a la derecha
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Lumind: Entorno inicializado ⚡️',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}