import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- IMPORTANTE: Traemos Supabase
import '../../bloc/tarea/tarea_bloc.dart';
import '../../bloc/tarea/tarea_event.dart';
import '../../bloc/tarea/tarea_state.dart';
import '../../bloc/pomodoro/pomodoro_bloc.dart';
import '../../bloc/pomodoro/pomodoro_event.dart';

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  final TextEditingController _controlador = TextEditingController();
  
  // 🎯 EL CAMBIO CLAVE: Le pedimos a Supabase el ID único del usuario que acaba de loguearse
  final String _usuarioId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    // Cargamos las tareas específicas de este usuario real
    context.read<TareaBloc>().add(CargarTareas(_usuarioId));
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'MIS TAREAS',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controlador,
                  decoration: InputDecoration(
                    hintText: '¿Qué necesitas hacer hoy?',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle_rounded, color: Colors.blueAccent, size: 30),
                      onPressed: () {
                        if (_controlador.text.trim().isNotEmpty) {
                          context.read<TareaBloc>().add(
                            AgregarTarea(titulo: _controlador.text, usuarioId: _usuarioId),
                          );
                          _controlador.clear();
                        }
                      },
                    ),
                  ),
                  onSubmitted: (valor) {
                    if (valor.trim().isNotEmpty) {
                      context.read<TareaBloc>().add(
                        AgregarTarea(titulo: valor, usuarioId: _usuarioId),
                      );
                      _controlador.clear();
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: BlocBuilder<TareaBloc, TareaState>(
                  builder: (context, state) {
                    if (state is TareaLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.black87));
                    } else if (state is TareaLoaded) {
                      if (state.tareas.isEmpty) {
                        return Center(
                          child: Text(
                            'Todo al día. ¡A disfrutar del descanso!',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: state.tareas.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final tarea = state.tareas[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: GestureDetector(
                                onTap: () => context.read<TareaBloc>().add(CambiarEstadoTarea(id: tarea.id, estaCompletada: !tarea.estaCompletada)),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: tarea.estaCompletada ? Colors.blueAccent : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    color: tarea.estaCompletada ? Colors.blueAccent : Colors.transparent,
                                  ),
                                  child: tarea.estaCompletada ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                ),
                              ),
                              title: Text(
                                tarea.titulo,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: tarea.estaCompletada ? Colors.grey.shade400 : Colors.black87,
                                  decoration: tarea.estaCompletada ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.track_changes_rounded, color: Colors.blueAccent),
                                tooltip: 'Enfocar en esta tarea',
                                onPressed: () {
                                  context.read<PomodoroBloc>().add(SeleccionarTareaPomodoro(tareaId: tarea.id, tituloTarea: tarea.titulo));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('🎯 Enfocando en: ${tarea.titulo}'),
                                      backgroundColor: Colors.black87,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is TareaError) {
                      return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }
}