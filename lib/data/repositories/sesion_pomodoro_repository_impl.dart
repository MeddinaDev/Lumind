import '../../domain/entities/sesion_pomodoro.dart';
import '../../domain/repositories/sesion_pomodoro_repository.dart';
import '../datasources/sesion_pomodoro_remote_data_source.dart';

class SesionPomodoroRepositoryImpl implements SesionPomodoroRepository {
  final SesionPomodoroRemoteDataSource remoteDataSource;

  SesionPomodoroRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SesionPomodoro> registrarSesion({
    required String usuarioId,
    required int duracionMinutos,
    required int puntosGanados,
    String? tareaId,
  }) async {
    return await remoteDataSource.registrarSesion(
      usuarioId: usuarioId,
      duracionMinutos: duracionMinutos,
      puntosGanados: puntosGanados,
      tareaId: tareaId,
    );
  }
}