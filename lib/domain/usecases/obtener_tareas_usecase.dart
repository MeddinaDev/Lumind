import '../entities/tarea.dart';
import '../repositories/tarea_repository.dart';

class ObtenerTareasUseCase {
  final TareaRepository repository;

  ObtenerTareasUseCase(this.repository);

  Future<List<Tarea>> call(String usuarioId) {
    if (usuarioId.trim().isEmpty) {
      throw Exception('El ID de usuario no puede estar vacío');
    }
    return repository.obtenerTareas(usuarioId);
  }
}