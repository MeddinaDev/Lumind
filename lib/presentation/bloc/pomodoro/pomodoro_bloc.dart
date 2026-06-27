import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- IMPORTANTE: Añade esta importación
import '../../../domain/usecases/registrar_sesion_pomodoro_usecase.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final RegistrarSesionPomodoroUseCase registrarSesionUseCase;

  String? tareaIdSeleccionada;
  String? tituloTareaSeleccionada;

  PomodoroBloc({required this.registrarSesionUseCase}) : super(PomodoroInitial()) {
    
    // ... Tus otros manejadores de eventos (Iniciar, Pausar, Reanudar, Resetear) ...

    on<SeleccionarTareaPomodoro>((event, emit) {
      tareaIdSeleccionada = event.tareaId;
      tituloTareaSeleccionada = event.tituloTarea;
      emit(PomodoroPaused(segundosRestantes: 1500));
    });

    // 🎯 EL AJUSTE CLAVE: Modificamos el evento de guardado
    on<GuardarSesionPomodoro>((event, emit) async {
      emit(PomodoroGuardando());
      try {
        // Extraemos el ID del usuario autenticado en tiempo real
        final usuarioRealId = Supabase.instance.client.auth.currentUser!.id;

        await registrarSesionUseCase.call(
          usuarioId: usuarioRealId, // <-- Usamos el ID dinámico aquí
          duracionMinutos: event.duracionMinutos,
          puntosGanados: event.puntosGanados,
          tareaId: tareaIdSeleccionada, // Vincula la tarea si había una seleccionada
        );

        emit(PomodoroGuardadoExito());
      } catch (e) {
        emit(PomodoroError(e.toString()));
      }
    });
  }

  // ... Recuerda comprobar también si tienes la lógica de guardado automático 
  // cuando el Ticker del Timer llega a 0, para que dispare el evento pasando el ID real o llamando a esta misma lógica.
}