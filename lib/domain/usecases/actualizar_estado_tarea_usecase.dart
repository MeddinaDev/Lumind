import '../entities/tarea.dart';
import '../repositories/tarea_repository.dart';

class ActualizarEstadoTareaUseCase {
  final TareaRepository repository;

  ActualizarEstadoTareaUseCase(this.repository);

  Future<Tarea> call(String id, bool estaCompletada) {
    if (id.trim().isEmpty) {
      throw Exception('El ID de la tarea no puede estar vacío');
    }
    return repository.actualizarEstado(id, estaCompletada);
  }
}