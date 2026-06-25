import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/obtener_tareas_usecase.dart';
import '../../../domain/usecases/crear_tarea_usecase.dart';
import '../../../domain/usecases/actualizar_estado_tarea_usecase.dart';
import 'tarea_event.dart';
import 'tarea_state.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final ObtenerTareasUseCase obtenerTareasUseCase;
  final CrearTareaUseCase crearTareaUseCase;
  final ActualizarEstadoTareaUseCase actualizarEstadoTareaUseCase;

  TareaBloc({
    required this.obtenerTareasUseCase,
    required this.crearTareaUseCase,
    required this.actualizarEstadoTareaUseCase,
  }) : super(TareaInitial()) {
    
    // Al escuchar el evento CargarTareas...
    on<CargarTareas>((event, emit) async {
      emit(TareaLoading()); // Mostramos cargando
      try {
        final tareas = await obtenerTareasUseCase(event.usuarioId);
        emit(TareaLoaded(tareas)); // Mostramos la lista
      } catch (e) {
        emit(TareaError(e.toString()));
      }
    });

    // Al escuchar el evento AgregarTarea...
    on<AgregarTarea>((event, emit) async {
      // Guardamos el estado actual por si acaso
      final currentState = state;
      try {
        final nuevaTarea = await crearTareaUseCase(event.titulo, event.usuarioId);
        
        // Si ya teníamos una lista cargada, le añadimos la nueva tarea para no recargar toda la pantalla
        if (currentState is TareaLoaded) {
          final nuevasTareas = List.of(currentState.tareas)..insert(0, nuevaTarea);
          emit(TareaLoaded(nuevasTareas));
        } else {
          // Si no había lista, cargamos la lista entera desde cero
          add(CargarTareas(event.usuarioId));
        }
      } catch (e) {
        emit(TareaError(e.toString()));
      }
    });

    // Al escuchar el evento CambiarEstadoTarea...
    on<CambiarEstadoTarea>((event, emit) async {
      final currentState = state;
      try {
        final tareaActualizada = await actualizarEstadoTareaUseCase(event.id, event.estaCompletada);
        
        if (currentState is TareaLoaded) {
          // Buscamos la tarea en la lista actual y la cambiamos por la actualizada
          final nuevasTareas = currentState.tareas.map((t) {
            return t.id == tareaActualizada.id ? tareaActualizada : t;
          }).toList();
          
          emit(TareaLoaded(nuevasTareas));
        }
      } catch (e) {
        emit(TareaError(e.toString()));
      }
    });
  }
}