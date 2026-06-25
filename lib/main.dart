import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importaciones de tus capas
import 'data/datasources/usuario_remote_data_source.dart';
import 'data/repositories/usuario_repository_impl.dart';
import 'domain/usecases/crear_usuario_usecase.dart';
import 'presentation/bloc/usuario/usuario_bloc.dart';
import 'presentation/bloc/usuario/usuario_event.dart';
import 'presentation/bloc/usuario/usuario_state.dart';

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
    // 1. Instanciamos el cliente de Supabase
    final supabaseClient = Supabase.instance.client;

    // 2. Inyectamos las dependencias siguiendo la Clean Architecture
    final remoteDataSource = UsuarioRemoteDataSourceImpl(supabaseClient: supabaseClient);
    final usuarioRepository = UsuarioRepositoryImpl(remoteDataSource: remoteDataSource);
    final crearUsuarioUseCase = CrearUsuarioUseCase(usuarioRepository);

    return MaterialApp(
      title: 'Lumind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // 3. Proveemos el BLOC a toda la aplicación
      home: BlocProvider(
        create: (context) => UsuarioBloc(crearUsuarioUseCase: crearUsuarioUseCase),
        child: const PantallaPruebaUsuario(),
      ),
    );
  }
}

class PantallaPruebaUsuario extends StatefulWidget {
  const PantallaPruebaUsuario({super.key});

  @override
  State<PantallaPruebaUsuario> createState() => _PantallaPruebaUsuarioState();
}

class _PantallaPruebaUsuarioState extends State<PantallaPruebaUsuario> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumind: Panel de Prueba ⚡️'),
        backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del nuevo usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final nombre = _nombreController.text;
                if (nombre.trim().isNotEmpty) {
                  // Disparamos el evento hacia el BLOC
                  context.read<UsuarioBloc>().add(CrearNuevoUsuario(nombre));
                }
              },
              child: const Text('Insertar en Supabase', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 40),
            // El buscador de estados que redibuja la pantalla según el BLOC
            BlocBuilder<UsuarioBloc, UsuarioState>(
              builder: (context, state) {
                if (state is UsuarioLoading) {
                  return const CircularProgressIndicator();
                } else if (state is UsuarioLoaded) {
                  _nombreController.clear(); // Limpiamos el input si todo va bien
                  return Card(
                    color: Colors.green.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 40),
                          const SizedBox(height: 10),
                          Text('¡Usuario creado con éxito!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
                          const SizedBox(height: 5),
                          Text('Nombre: ${state.usuario.nombre}'),
                          Text('UUID: ${state.usuario.id}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                } else if (state is UsuarioError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  );
                }
                return const Text('Introduce un nombre para probar el flujo.');
              },
            ),
          ],
        ),
      ),
    );
  }
}