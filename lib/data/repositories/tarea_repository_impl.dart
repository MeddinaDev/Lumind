import '../../domain/entities/tarea.dart';
import '../../domain/repositories/tarea_repository.dart';
import '../datasources/tarea_remote_data_source.dart';

class TareaRepositoryImpl implements TareaRepository {
  final TareaRemoteDataSource remoteDataSource;

  TareaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Tarea>> obtenerTareas(String usuarioId) async {
    // Obtenemos las tareas del usuario
    return await remoteDataSource.obtenerTareas(usuarioId);
  }

  @override
  Future<Tarea> crearTarea(String titulo, String usuarioId) async {
    return await remoteDataSource.crearTarea(titulo, usuarioId);
  }

  @override
  Future<Tarea> actualizarEstado(String id, bool estaCompletada) async {
    return await remoteDataSource.actualizarEstado(id, estaCompletada);
  }
}