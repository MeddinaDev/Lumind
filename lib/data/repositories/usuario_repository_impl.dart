import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_data_source.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource remoteDataSource;

  UsuarioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Usuario> crearUsuario(String nombre) async {
    // 1. Pedimos los datos a Supabase a través del DataSource
    final usuarioModel = await remoteDataSource.crearUsuario(nombre);
    
    // 2. Retornamos el Model (como UsuarioModel hereda de Usuario, cumple perfectamente el contrato del Dominio).
    return usuarioModel;
  }
}