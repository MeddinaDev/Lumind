import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class CrearUsuarioUseCase {
  final UsuarioRepository repository;

  CrearUsuarioUseCase(this.repository);

  Future<Usuario> call(String nombre) {
    // Aquí podríamos meter lógica extra antes de enviarlo al repositorio.
    if (nombre.trim().isEmpty) {
      throw Exception('El nombre no puede estar vacío');
    }
    return repository.crearUsuario(nombre);
  }
}