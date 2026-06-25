import '../entities/sesion_pomodoro.dart';
import '../repositories/sesion_pomodoro_repository.dart';

class RegistrarSesionPomodoroUseCase {
  final SesionPomodoroRepository repository;

  RegistrarSesionPomodoroUseCase(this.repository);

  Future<SesionPomodoro> call({
    required String usuarioId,
    required int duracionMinutos,
    required int puntosGanados,
    String? tareaId,
  }) {
    // Reglas de negocio: seguridad antes de enviar nada
    if (usuarioId.trim().isEmpty) {
      throw Exception('El ID del usuario es obligatorio para registrar la sesión.');
    }
    if (duracionMinutos <= 0) {
      throw Exception('La duración de la sesión debe ser de al menos 1 minuto.');
    }

    return repository.registrarSesion(
      usuarioId: usuarioId,
      duracionMinutos: duracionMinutos,
      puntosGanados: puntosGanados,
      tareaId: tareaId,
    );
  }
}