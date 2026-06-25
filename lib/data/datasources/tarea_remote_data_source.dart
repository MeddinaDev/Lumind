import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tarea_model.dart';

abstract class TareaRemoteDataSource {
  Future<List<TareaModel>> obtenerTareas(String usuarioId);
  Future<TareaModel> crearTarea(String titulo, String usuarioId);
  Future<TareaModel> actualizarEstado(String id, bool estaCompletada);
}

class TareaRemoteDataSourceImpl implements TareaRemoteDataSource {
  final SupabaseClient supabaseClient;

  TareaRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TareaModel>> obtenerTareas(String usuarioId) async {
    final response = await supabaseClient
        .from('tarea')
        .select()
        .eq('usuario_id', usuarioId)
        .order('fecha_creacion', ascending: false);

    return (response as List).map((json) => TareaModel.fromJson(json)).toList();
  }

  @override
  Future<TareaModel> crearTarea(String titulo, String usuarioId) async {
    final response = await supabaseClient
        .from('tarea')
        .insert({
          'titulo': titulo,
          'usuario_id': usuarioId,
          'esta_completada': false, 
        })
        .select()
        .single();

    return TareaModel.fromJson(response);
  }

  @override
  Future<TareaModel> actualizarEstado(String id, bool estaCompletada) async {
    final response = await supabaseClient
        .from('tarea')
        .update({'esta_completada': estaCompletada})
        .eq('id', id)
        .select()
        .single();

    return TareaModel.fromJson(response);
  }
}