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
    // ⚡️ CHIVATO: Imprimimos en la consola de tu Mac qué nos devuelve Supabase

    return SesionPomodoroModel(
      // Ponemos un salvavidas (??) a los String para que si llega null no salte la pantalla roja
      id: json['id'] ?? 'ID_NO_GENERADO',
      usuarioId: json['usuario_id'] ?? json['user_id'] ?? 'USUARIO_VACIO',
      duracionMinutos: json['duracion_minutos'] ?? 25,
      // Manejamos las fechas para que nunca fallen si vienen nulas
      fechaHora: json['fecha_hora'] != null
          ? DateTime.parse(json['fecha_hora'])
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
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
    
    if (tareaId != null) {
      map['tarea_id'] = tareaId!;
    }
    
    return map;
  }
}