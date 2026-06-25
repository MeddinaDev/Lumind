import '../entities/tarea.dart';
import '../repositories/tarea_repository.dart';

class CrearTareaUseCase {
  final TareaRepository repository;

  CrearTareaUseCase(this.repository);

  Future<Tarea> call(String titulo, String usuarioId) {
    if (titulo.trim().isEmpty) {
      throw Exception('El título de la tarea no puede estar vacío');
    }
    return repository.crearTarea(titulo, usuarioId);
  }
}