import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pantalla_principal.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _estaCargando = false;

  // Instancia de Supabase para la autenticación
  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función para iniciar sesión
  Future<void> _iniciarSesion() async {
    setState(() => _estaCargando = true);
    try {
      await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
        );
      }
    } on AuthException catch (error) {
      _mostrarError(error.message);
    } catch (error) {
      _mostrarError('Ocurrió un error inesperado');
    } finally {
      if (mounted) setState(() => _estaCargando = false);
    }
  }

  // Función para registrar una cuenta nueva
  Future<void> _registrarCuenta() async {
    setState(() => _estaCargando = true);
    try {
      await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _mostrarMensaje('¡Cuenta creada! Revisa tu email para confirmar (si lo configuraste en Supabase), o inicia sesión directamente.');
    } on AuthException catch (error) {
      _mostrarError(error.message);
    } catch (error) {
      _mostrarError('Ocurrió un error inesperado');
    } finally {
      if (mounted) setState(() => _estaCargando = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Fondo limpio corporativo
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logotipo tipográfico minimalista
                const Text(
                  'LUMIND',
                  style: TextStyle(
                    fontSize: 32,
                    letterSpacing: 8.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enfoque absoluto.',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 64),

                // Campo de Email
                _ConstruirCampoTexto(
                  controlador: _emailController,
                  hint: 'Correo electrónico',
                  icono: Icons.email_outlined,
                  esOculto: false,
                ),
                const SizedBox(height: 16),

                // Campo de Contraseña
                _ConstruirCampoTexto(
                  controlador: _passwordController,
                  hint: 'Contraseña',
                  icono: Icons.lock_outline_rounded,
                  esOculto: true,
                ),
                const SizedBox(height: 40),

                // Botones de acción
                if (_estaCargando)
                  const CircularProgressIndicator(color: Colors.black87)
                else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _iniciarSesion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _registrarCuenta,
                    child: const Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: Colors.black54)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para mantener el código limpio y los campos elegantes
class _ConstruirCampoTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String hint;
  final IconData icono;
  final bool esOculto;

  const _ConstruirCampoTexto({
    required this.controlador,
    required this.hint,
    required this.icono,
    required this.esOculto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controlador,
        obscureText: esOculto,
        keyboardType: esOculto ? TextInputType.text : TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
          prefixIcon: Icon(icono, color: Colors.black26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}