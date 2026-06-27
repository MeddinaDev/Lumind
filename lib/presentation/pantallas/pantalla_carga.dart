import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pantalla_login.dart';
import 'pantalla_principal.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    _redirigir();
  }

  Future<void> _redirigir() async {
    // Damos un segundo de margen para que se vea el logo elegante
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;

    // Preguntamos a Supabase si ya hay un usuario guardado en el dispositivo
    final sesion = Supabase.instance.client.auth.currentSession;

    if (sesion != null) {
      // Si ya estaba logueado, directo adentro
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
      );
    } else {
      // Si no, a la pantalla de login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PantallaLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LUMIND',
              style: TextStyle(
                fontSize: 32,
                letterSpacing: 8.0,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            // Un indicador de carga muy sutil
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.black26,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}