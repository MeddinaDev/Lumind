import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario_model.dart';

// 1. La Interfaz 
abstract class UsuarioRemoteDataSource {
  Future<UsuarioModel> crearUsuario(String nombre);
}

// 2. La Implementación real conectada a Supabase
class UsuarioRemoteDataSourceImpl implements UsuarioRemoteDataSource {
  final SupabaseClient supabaseClient;

  UsuarioRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UsuarioModel> crearUsuario(String nombre) async {
    // Apuntamos a la tabla 'usuario', insertamos el nombre y pedimos que nos devuelva la fila completa (.select().single()) con el UUID ya generado.
    final response = await supabaseClient
        .from('usuario')
        .insert({'nombre': nombre})
        .select()
        .single();

    // Traducimos la respuesta de Supabase al Modelo
    return UsuarioModel.fromJson(response);
  }
}