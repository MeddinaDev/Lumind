import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // 1. Aseguramos que los bindings de Flutter estén listos antes de iniciar servicios asíncronos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializo la conexión con la base de datos en la nube
  await Supabase.initialize(
    url: 'https://ubstaujgjthsfkccokws.supabase.co/rest/v1/',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVic3RhdWpnanRoc2ZrY2Nva3dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIwNjM0NjcsImV4cCI6MjA5NzYzOTQ2N30.SVsmLxkIiAfw0PAEQTPPxaH8bgPIvBTGpFzuescZ-B8',
  );

  runApp(const LumindApp());
}

class LumindApp extends StatelessWidget {
  const LumindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Lumind: Conectado a Supabase ⚡️',
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