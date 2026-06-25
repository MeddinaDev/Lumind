import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
import 'presentation/bloc/pomodoro/pomodoro_event.dart';
import 'presentation/bloc/pomodoro/pomodoro_state.dart';

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const PantallaPruebaPomodoro(),
      ),
    );
  }
}

class PantallaPruebaPomodoro extends StatelessWidget {
  const PantallaPruebaPomodoro({super.key});

  // UUID de tu usuario en Supabase
  final String _usuarioIdTemporal = '5ad778e2-9a11-4b05-9c03-8943b54d92c4';

  // Función auxiliar para transformar segundos puros a formato MM:SS
  String _formatearTiempo(int segundosTotales) {
    final minutos = (segundosTotales ~/ 60).toString().padLeft(2, '0');
    final segundos = (segundosTotales % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumind: Lógica del Temporizador ⏱️'),
        backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<PomodoroBloc, PomodoroState>(
            listener: (context, state) {
              if (state is PomodoroGuardadoExito) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Sesión guardada en Supabase y puntos sumados! 🚀'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is PomodoroError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al guardar: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              int segundosAMostrar = 1500; // 25 minutos por defecto en pantalla
              bool estaCorriendo = false;
              bool estaPausado = false;

              if (state is PomodoroRunning) {
                segundosAMostrar = state.segundosRestantes;
                estaCorriendo = true;
              } else if (state is PomodoroPaused) {
                segundosAMostrar = state.segundosRestantes;
                estaPausado = true;
              } else if (state is PomodoroGuardando) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Guardando sesión de enfoque en Supabase...'),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gran reloj digital
                  Text(
                    _formatearTiempo(segundosAMostrar),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier', // Estilo marcador
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Fila de controles de flujo de tiempo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!estaCorriendo && !estaPausado) ...[
                        ElevatedButton.icon(
                          onPressed: () => context.read<PomodoroBloc>().add(const IniciarPomodoro(minutos: 1)),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Test (1 Min)'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => context.read<PomodoroBloc>().add(const IniciarPomodoro(minutos: 25)),
                          icon: const Icon(Icons.timer),
                          label: const Text('Pomodoro (25 Min)'),
                        ),
                      ],
                      if (estaCorriendo)
                        ElevatedButton.icon(
                          onPressed: () => context.read<PomodoroBloc>().add(PausarPomodoro()),
                          icon: const Icon(Icons.pause),
                          label: const Text('Pausar'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                        ),
                      if (estaPausado) ...[
                        ElevatedButton.icon(
                          onPressed: () => context.read<PomodoroBloc>().add(ReanudarPomodoro()),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Reanudar'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => context.read<PomodoroBloc>().add(ResetearPomodoro()),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Resetear'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Botón directo para simular la inserción en base de datos
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      context.read<PomodoroBloc>().add(
                            GuardarSesionPomodoro(
                              usuarioId: _usuarioIdTemporal,
                              duracionMinutos: 25,
                              puntosGanados: 50, // 50 puntazos para el marcador
                            ),
                          );
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Simular Guardado Directo en Supabase'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}