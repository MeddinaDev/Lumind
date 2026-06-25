import '../../domain/entities/sesion_pomodoro.dart';

class SesionPomodoroModel extends SesionPomodoro {
  const SesionPomodoroModel({
    required super.id,
    required super.usuarioId,
    required super.duracionMinutos,
    required super.fechaHora,
    super.puntosGanados = 0,
    super.tareaId,
  });

  // Traductor: De Supabase (JSON) a nuestra App
  factory SesionPomodoroModel.fromJson(Map<String, dynamic> json) {
    return SesionPomodoroModel(
      id: json['id'],
      usuarioId: json['usuario_id'],
      duracionMinutos: json['duracion_minutos'] ?? 25,
      // Usamos fecha_hora o created_at según lo hayas nombrado en tu base de datos
      fechaHora: DateTime.parse(json['fecha_hora'] ?? json['created_at']), 
      puntosGanados: json['puntos_ganados'] ?? 0,
      tareaId: json['tarea_id'],
    );
  }

  // Traductor: De nuestra App a Supabase (JSON)
  Map<String, dynamic> toJson() {
    final map = {
      'usuario_id': usuarioId,
      'duracion_minutos': duracionMinutos,
      'puntos_ganados': puntosGanados,
    };
    
    // Solo enviamos el tarea_id a Supabase si realmente está vinculada a una tarea
    if (tareaId != null) {
      map['tarea_id'] = tareaId!;
    }
    
    return map;
  }
}