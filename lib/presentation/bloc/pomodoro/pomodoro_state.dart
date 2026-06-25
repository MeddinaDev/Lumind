import 'package:equatable/equatable.dart';

abstract class PomodoroState extends Equatable {
  const PomodoroState();

  @override
  List<Object?> get props => [];
}

// 1. Estado inicial: el reloj está parado esperando a que el usuario le dé al Play
class PomodoroInitial extends PomodoroState {}

// 2. Corriendo: muestra los segundos que quedan en pantalla
class PomodoroRunning extends PomodoroState {
  final int segundosRestantes;

  const PomodoroRunning({required this.segundosRestantes});

  @override
  List<Object?> get props => [segundosRestantes];
}

// 3. Pausado: congela los segundos en pantalla
class PomodoroPaused extends PomodoroState {
  final int segundosRestantes;

  const PomodoroPaused({required this.segundosRestantes});

  @override
  List<Object?> get props => [segundosRestantes];
}

// 4. Guardando en la nube: cuando el tiempo termina y está registrando en Supabase
class PomodoroGuardando extends PomodoroState {}

// 5. Éxito: la sesión se ha guardado correctamente y sumado los puntos
class PomodoroGuardadoExito extends PomodoroState {}

// 6. Error: por si falla la conexión al guardar la sesión
class PomodoroError extends PomodoroState {
  final String message;

  const PomodoroError(this.message);

  @override
  List<Object?> get props => [message];
}