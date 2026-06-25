import '../entities/tarea.dart';

abstract class TareaRepository {
  // Solo definimos las tres acciones principales
  Future<List<Tarea>> obtenerTareas(String usuarioId);
  Future<Tarea> crearTarea(String titulo, String usuarioId);
  Future<Tarea> actualizarEstado(String id, bool estaCompletada);
}