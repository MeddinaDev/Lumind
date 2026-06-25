import 'package:equatable/equatable.dart';
import '../../../domain/entities/tarea.dart';

abstract class TareaState extends Equatable {
  const TareaState();
  
  @override
  List<Object> get props => [];
}

// 1. Estado inicial sin nada
class TareaInitial extends TareaState {}

// 2. Estado de carga (para mostrar la ruedita)
class TareaLoading extends TareaState {}

// 3. Estado de éxito (tiene la lista de tareas listas para mostrar)
class TareaLoaded extends TareaState {
  final List<Tarea> tareas;

  const TareaLoaded(this.tareas);

  @override
  List<Object> get props => [tareas];
}

// 4. Estado de error (por si falla el internet o Supabase)
class TareaError extends TareaState {
  final String message;

  const TareaError(this.message);

  @override
  List<Object> get props => [message];
}