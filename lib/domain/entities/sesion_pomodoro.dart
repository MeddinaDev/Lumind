import 'package:equatable/equatable.dart';

class SesionPomodoro extends Equatable {
  final String id;
  final int duracionMinutos;
  final DateTime fechaHora;
  final int puntosGanados;
  final String? tareaId; // Nullable porque la relación es opcional

  const SesionPomodoro({
    required this.id,
    required this.duracionMinutos,
    required this.fechaHora,
    this.puntosGanados = 0,
    this.tareaId,
  });

  // Método equivalente a editar() para mantener la inmutabilidad
  SesionPomodoro copyWith({
    String? id,
    int? duracionMinutos,
    DateTime? fechaHora,
    int? puntosGanados,
    String? tareaId,
  }) {
    return SesionPomodoro(
      id: id ?? this.id,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      fechaHora: fechaHora ?? this.fechaHora,
      puntosGanados: puntosGanados ?? this.puntosGanados,
      tareaId: tareaId ?? this.tareaId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        duracionMinutos,
        fechaHora,
        puntosGanados,
        tareaId,
      ];
}
