import '../entities/usuario.dart';

abstract class UsuarioRepository {
  // El dominio solo exige que le devuelvan un Usuario, no le importa si viene de Supabase, de SQLite o de una paloma mensajera.
  Future<Usuario> crearUsuario(String nombre);
}
