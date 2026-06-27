import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/pantallas/pantalla_carga.dart';
import 'presentation/theme_lumind.dart';

// Importaciones de Usuario
import 'data/datasources/usuario_remote_data_source.dart';
import 'data/repositories/usuario_repository_impl.dart';
import 'domain/usecases/crear_usuario_usecase.dart';
import 'presentation/bloc/usuario/usuario_bloc.dart';

// Importaciones de Tarea
import 'data/datasources/tarea_remote_data_source.dart';
import 'data/repositories/tarea_repository_impl.dart';
import 'domain/usecases/obtener_tareas_usecase.dart';
import 'domain/usecases/crear_tarea_usecase.dart';
import 'domain/usecases/actualizar_estado_tarea_usecase.dart';
import 'presentation/bloc/tarea/tarea_bloc.dart';

// Importaciones de Pomodoro
import 'data/datasources/sesion_pomodoro_remote_data_source.dart';
import 'data/repositories/sesion_pomodoro_repository_impl.dart';
import 'domain/usecases/registrar_sesion_pomodoro_usecase.dart';
import 'presentation/bloc/pomodoro/pomodoro_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase
  await Supabase.initialize(
    url: 'https://ubstaujgjthsfkccokws.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVic3RhdWpnanRoc2ZrY2Nva3dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIwNjM0NjcsImV4cCI6MjA5NzYzOTQ2N30.SVsmLxkIiAfw0PAEQTPPxaH8bgPIvBTGpFzuescZ-B8',
  );

  runApp(const LumindApp());
}

class LumindApp extends StatelessWidget {
  const LumindApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    // 1. Dependencias de Usuario
    final usuarioRemoteDS = UsuarioRemoteDataSourceImpl(supabaseClient: supabaseClient);
    final usuarioRepo = UsuarioRepositoryImpl(remoteDataSource: usuarioRemoteDS);
    final crearUsuarioUC = CrearUsuarioUseCase(usuarioRepo);

    // 2. Dependencias de Tarea
    final tareaRemoteDS = TareaRemoteDataSourceImpl(supabaseClient: supabaseClient);
    final tareaRepo = TareaRepositoryImpl(remoteDataSource: tareaRemoteDS);
    final obtenerTareasUC = ObtenerTareasUseCase(tareaRepo);
    final crearTareaUC = CrearTareaUseCase(tareaRepo);
    final actualizarEstadoUC = ActualizarEstadoTareaUseCase(tareaRepo);

    // 3. Dependencias de Pomodoro
    final pomodoroRemoteDS = SesionPomodoroRemoteDataSourceImpl(supabaseClient: supabaseClient);
    final pomodoroRepo = SesionPomodoroRepositoryImpl(remoteDataSource: pomodoroRemoteDS);
    final registrarSesionUC = RegistrarSesionPomodoroUseCase(pomodoroRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UsuarioBloc(crearUsuarioUseCase: crearUsuarioUC)),
        BlocProvider(
          create: (context) => TareaBloc(
            obtenerTareasUseCase: obtenerTareasUC,
            crearTareaUseCase: crearTareaUC,
            actualizarEstadoTareaUseCase: actualizarEstadoUC,
          ),
        ),
        BlocProvider(
          create: (context) => PomodoroBloc(registrarSesionUseCase: registrarSesionUC),
        ),
      ],
      child: MaterialApp(
        title: 'Lumind',
        debugShowCheckedModeBanner: false, 
        theme: ThemeLumind.lightTheme,
        home: const PantallaCarga(),
      ),
    );
  }
}