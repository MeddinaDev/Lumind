import '../entities/sesion_pomodoro.dart';

abstract class SesionPomodoroRepository {
  Future<SesionPomodoro> registrarSesion({
    required String usuarioId,
    required int duracionMinutos,
    required int puntosGanados,
    String? tareaId,
  });
}