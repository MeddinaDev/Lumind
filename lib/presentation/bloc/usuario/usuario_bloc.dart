import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/crear_usuario_usecase.dart';
import 'usuario_event.dart';
import 'usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  final CrearUsuarioUseCase crearUsuarioUseCase;

  UsuarioBloc({required this.crearUsuarioUseCase}) : super(UsuarioInitial()) {
    on<CrearNuevoUsuario>((event, emit) async {
      // 1. Avisamos a la pantalla de que muestre el circulito de carga
      emit(UsuarioLoading());
      
      try {
        // 2. Ejecutamos el Caso de Uso (que viaja hasta Supabase)
        final nuevoUsuario = await crearUsuarioUseCase(event.nombre);
        
        // 3. Si todo va bien, devolvemos el usuario creado con su UUID
        emit(UsuarioLoaded(nuevoUsuario));
      } catch (e) {
        // 4. Si algo falla (ej. pérdida de conexión), mostramos el error
        emit(UsuarioError(e.toString()));
      }
    });
  }
}