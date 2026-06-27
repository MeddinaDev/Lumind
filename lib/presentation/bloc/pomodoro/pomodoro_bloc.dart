import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/usecases/registrar_sesion_pomodoro_usecase.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final RegistrarSesionPomodoroUseCase registrarSesionUseCase;
  
  Timer? _timer;
  String? tareaIdSeleccionada;
  String? tituloTareaSeleccionada;
  int _segundosActuales = 1500;

  PomodoroBloc({required this.registrarSesionUseCase}) : super(PomodoroInitial()) {
    
    on<SeleccionarTareaPomodoro>((event, emit) {
      tareaIdSeleccionada = event.tareaId;
      tituloTareaSeleccionada = event.tituloTarea;
      if (state is PomodoroInitial) {
         emit(PomodoroInitial());
      } else {
         emit(PomodoroPaused(segundosRestantes: _segundosActuales));
      }
    });

    on<IniciarPomodoro>((event, emit) {
      _timer?.cancel();
      _segundosActuales = event.minutos * 60;
      emit(PomodoroRunning(segundosRestantes: _segundosActuales));
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _segundosActuales--;
        if (_segundosActuales > 0) {
          add(TicPomodoro(_segundosActuales));
        } else {
          timer.cancel();
          final uid = Supabase.instance.client.auth.currentUser!.id;
          add(GuardarSesionPomodoro(usuarioId: uid, duracionMinutos: event.minutos, puntosGanados: event.minutos * 10));        }
      });
    });

    on<TicPomodoro>((event, emit) {
      emit(PomodoroRunning(segundosRestantes: event.segundosRestantes));
    });

    on<PausarPomodoro>((event, emit) {
      _timer?.cancel();
      emit(PomodoroPaused(segundosRestantes: _segundosActuales));
    });

    on<ReanudarPomodoro>((event, emit) {
      _timer?.cancel();
      emit(PomodoroRunning(segundosRestantes: _segundosActuales));
      
      int minutosOriginales = (_segundosActuales ~/ 60) > 0 ? (_segundosActuales ~/ 60) : 1;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _segundosActuales--;
        if (_segundosActuales > 0) {
          add(TicPomodoro(_segundosActuales));
        } else {
          timer.cancel();
          final uid = Supabase.instance.client.auth.currentUser!.id;
          add(GuardarSesionPomodoro(usuarioId: uid, duracionMinutos: minutosOriginales, puntosGanados: minutosOriginales * 10));
        }
      });
    });

    on<ResetearPomodoro>((event, emit) {
      _timer?.cancel();
      _segundosActuales = 1500;
      emit(PomodoroInitial());
    });

    on<GuardarSesionPomodoro>((event, emit) async {
      emit(PomodoroGuardando());
      try {
        final usuarioRealId = Supabase.instance.client.auth.currentUser!.id;
        await registrarSesionUseCase.call(
          usuarioId: usuarioRealId,
          duracionMinutos: event.duracionMinutos,
          puntosGanados: event.puntosGanados,
          tareaId: tareaIdSeleccionada,
        );
        emit(PomodoroGuardadoExito());
        _segundosActuales = 1500; 
        emit(PomodoroInitial());
      } catch (e) {
        emit(PomodoroError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}