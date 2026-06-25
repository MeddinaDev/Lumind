import 'package:equatable/equatable.dart';

abstract class TareaEvent extends Equatable {
  const TareaEvent();

  @override
  List<Object> get props => [];
}

// Evento 1: Pedirle a Supabase la lista de tareas del usuario
class CargarTareas extends TareaEvent {
  final String usuarioId;

  const CargarTareas(this.usuarioId);

  @override
  List<Object> get props => [usuarioId];
}

// Evento 2: Crear una nueva tarea
class AgregarTarea extends TareaEvent {
  final String titulo;
  final String usuarioId;

  const AgregarTarea({required this.titulo, required this.usuarioId});

  @override
  List<Object> get props => [titulo, usuarioId];
}

// Evento 3: Marcar o desmarcar la tarea como completada
class CambiarEstadoTarea extends TareaEvent {
  final String id;
  final bool estaCompletada;

  const CambiarEstadoTarea({required this.id, required this.estaCompletada});

  @override
  List<Object> get props => [id, estaCompletada];
}