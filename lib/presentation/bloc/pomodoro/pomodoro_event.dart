import 'package:equatable/equatable.dart';

abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object?> get props => [];
}

// 1. Iniciar el cronómetro con un tiempo determinado (ej. 25 minutos)
class IniciarPomodoro extends PomodoroEvent {
  final int minutos;

  const IniciarPomodoro({required this.minutos});

  @override
  List<Object?> get props => [minutos];
}

// 2. Pausar la cuenta atrás
class PausarPomodoro extends PomodoroEvent {}

// 3. Reanudar el tiempo donde se quedó
class ReanudarPomodoro extends PomodoroEvent {}

// 4. Cancelar y volver al estado inicial
class ResetearPomodoro extends PomodoroEvent {}

// 5. Evento interno: se ejecuta automáticamente cada segundo que pasa
class TickPomodoro extends PomodoroEvent {
  final int segundosRestantes;

  const TickPomodoro({required this.segundosRestantes});

  @override
  List<Object?> get props => [segundosRestantes];
}

// 6. Tiempo completado: dispara el caso de uso para guardar en Supabase
class GuardarSesionPomodoro extends PomodoroEvent {
  final String usuarioId;
  final int duracionMinutos;
  final int puntosGanados;
  final String? tareaId;

  const GuardarSesionPomodoro({
    required this.usuarioId,
    required this.duracionMinutos,
    required this.puntosGanados,
    this.tareaId,
  });

  @override
  List<Object?> get props => [usuarioId, duracionMinutos, puntosGanados, tareaId];
}
class SeleccionarTareaPomodoro extends PomodoroEvent {
  final String? tareaId;
  final String? tituloTarea;

  const SeleccionarTareaPomodoro({this.tareaId, this.tituloTarea});
  
}
class TicPomodoro extends PomodoroEvent {
  final int segundosRestantes;
  const TicPomodoro(this.segundosRestantes);
}