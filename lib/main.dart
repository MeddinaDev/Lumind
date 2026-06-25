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
import 'presentation/bloc/tarea/tarea_event.dart';
import 'presentation/bloc/tarea/tarea_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Supabase
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

    // Inyección de dependencias de Usuario
    final usuarioRemoteDS = UsuarioRemoteDataSourceImpl(supabaseClient: supabaseClient);
    final usuarioRepo = UsuarioRepositoryImpl(remoteDataSource: usuarioRemoteDS);
    final crearUsuarioUC = CrearUsuarioUseCase(usuarioRepo);

    // Inyección de dependencias de Tarea
    final tareaRemoteDS = TareaRemoteDataSourceImpl(supabaseClient: supabaseClient);
    final tareaRepo = TareaRepositoryImpl(remoteDataSource: tareaRemoteDS);
    final obtenerTareasUC = ObtenerTareasUseCase(tareaRepo);
    final crearTareaUC = CrearTareaUseCase(tareaRepo);
    final actualizarEstadoUC = ActualizarEstadoTareaUseCase(tareaRepo);

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
      ],
      child: MaterialApp(
        title: 'Lumind',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const PantallaPruebaTareas(),
      ),
    );
  }
}

class PantallaPruebaTareas extends StatefulWidget {
  const PantallaPruebaTareas({super.key});

  @override
  State<PantallaPruebaTareas> createState() => _PantallaPruebaTareasState();
}

class _PantallaPruebaTareasState extends State<PantallaPruebaTareas> {
  final TextEditingController _tareaController = TextEditingController();
  
  final String _usuarioIdTemporal = '5ad778e2-9a11-4b05-9c03-8943b54d92c4';

  @override
  void initState() {
    super.initState();
    // Al arrancar, pedimos al BLOC que traiga las tareas
    context.read<TareaBloc>().add(CargarTareas(_usuarioIdTemporal));
  }

  @override
  void dispose() {
    _tareaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumind: Gestor de Tareas ⚡️'),
        backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Input para escribir la tarea
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tareaController,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(60, 54),
                  ),
                  onPressed: () {
                    final titulo = _tareaController.text;
                    if (titulo.trim().isNotEmpty) {
                      context.read<TareaBloc>().add(
                        AgregarTarea(titulo: titulo, usuarioId: _usuarioIdTemporal),
                      );
                      _tareaController.clear();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Lista de tareas conectada al BLOC
            Expanded(
              child: BlocBuilder<TareaBloc, TareaState>(
                builder: (context, state) {
                  if (state is TareaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TareaLoaded) {
                    if (state.tareas.isEmpty) {
                      return const Center(child: Text('No hay tareas pendientes. ¡Buen trabajo!'));
                    }
                    return ListView.builder(
                      itemCount: state.tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = state.tareas[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              tarea.titulo,
                              style: TextStyle(
                                decoration: tarea.estaCompletada
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            leading: Checkbox(
                              value: tarea.estaCompletada,
                              onChanged: (nuevoValor) {
                                if (nuevoValor != null) {
                                  context.read<TareaBloc>().add(
                                    CambiarEstadoTarea(
                                      id: tarea.id,
                                      estaCompletada: nuevoValor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is TareaError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(child: Text('Cargando flujo...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}