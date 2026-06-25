import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/registrar_sesion_pomodoro_usecase.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final RegistrarSesionPomodoroUseCase registrarSesionUseCase;
  
  // El StreamSubscription nos permite controlar el reloj interno
  StreamSubscription<int>? _tickerSubscription;

  PomodoroBloc({
    required this.registrarSesionUseCase,
  }) : super(PomodoroInitial()) {
    
    // 1. EVENTO: INICIAR
    on<IniciarPomodoro>((event, emit) {
      _tickerSubscription?.cancel(); 
      
      final segundosTotales = event.minutos * 60;
      emit(PomodoroRunning(segundosRestantes: segundosTotales));

      _tickerSubscription = Stream.periodic(const Duration(seconds: 1), (x) => x)
          .take(segundosTotales)
          .listen((tick) {
            final restantes = segundosTotales - tick - 1;
            add(TickPomodoro(segundosRestantes: restantes)); 
          });
    });

    // 2. EVENTO INTERNO: TICK
    on<TickPomodoro>((event, emit) {
      if (event.segundosRestantes > 0) {
        emit(PomodoroRunning(segundosRestantes: event.segundosRestantes));
      } else {
        _tickerSubscription?.cancel();
        emit(PomodoroInitial()); 
      }
    });

    // 3. EVENTO: PAUSAR
    on<PausarPomodoro>((event, emit) {
      final currentState = state;
      if (currentState is PomodoroRunning) {
        _tickerSubscription?.pause();
        emit(PomodoroPaused(segundosRestantes: currentState.segundosRestantes));
      }
    });

    // 4. EVENTO: REANUDAR
    on<ReanudarPomodoro>((event, emit) {
      final currentState = state;
      if (currentState is PomodoroPaused) {
        _tickerSubscription?.resume();
        emit(PomodoroRunning(segundosRestantes: currentState.segundosRestantes));
      }
    });

    // 5. EVENTO: RESETEAR
    on<ResetearPomodoro>((event, emit) {
      _tickerSubscription?.cancel();
      emit(PomodoroInitial());
    });

    // 6. EVENTO: GUARDAR EN SUPABASE
    on<GuardarSesionPomodoro>((event, emit) async {
      emit(PomodoroGuardando());
      try {
        await registrarSesionUseCase(
          usuarioId: event.usuarioId,
          duracionMinutos: event.duracionMinutos,
          puntosGanados: event.puntosGanados,
          tareaId: event.tareaId,
        );
        emit(PomodoroGuardadoExito());
      } catch (e) {
        emit(PomodoroError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}