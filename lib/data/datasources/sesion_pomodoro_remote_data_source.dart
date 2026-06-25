import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sesion_pomodoro_model.dart';

abstract class SesionPomodoroRemoteDataSource {
  Future<SesionPomodoroModel> registrarSesion({
    required String usuarioId,
    required int duracionMinutos,
    required int puntosGanados,
    String? tareaId,
  });
}

class SesionPomodoroRemoteDataSourceImpl implements SesionPomodoroRemoteDataSource {
  final SupabaseClient supabaseClient;

  SesionPomodoroRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<SesionPomodoroModel> registrarSesion({
    required String usuarioId,
    required int duracionMinutos,
    required int puntosGanados,
    String? tareaId,
  }) async {
    // 1. Preparamos los datos básicos que siempre van a ir
    final mapaDatos = {
      'usuario_id': usuarioId,
      'duracion_minutos': duracionMinutos,
      'puntos_ganados': puntosGanados,
    };

    // 2. Si la sesión estaba vinculada a una tarea, lo añadimos al paquete
    if (tareaId != null) {
      mapaDatos['tarea_id'] = tareaId;
    }

    // 3. Hacemos el envío a la tabla 'sesion_pomodoro' en Supabase
    final response = await supabaseClient
        .from('sesion_pomodoro')
        .insert(mapaDatos)
        .select()
        .single();

    // 4. Traducimos la respuesta de Supabase a nuestro modelo
    return SesionPomodoroModel.fromJson(response);
  }
}