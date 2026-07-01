import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Vibración del sistema
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pomodoro/pomodoro_bloc.dart';
import '../../bloc/pomodoro/pomodoro_event.dart';
import '../../bloc/pomodoro/pomodoro_state.dart';
import '../../theme_lumind.dart';

class PantallaTemporizador extends StatelessWidget {
  const PantallaTemporizador({super.key});

  String _formatearTiempo(int segundosTotales) {
    final minutos = (segundosTotales ~/ 60).toString().padLeft(2, '0');
    final segundos = (segundosTotales % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeLumind.fondo,
      body: SafeArea(
        child: BlocConsumer<PomodoroBloc, PomodoroState>(
          listener: (context, state) {
            if (state is PomodoroGuardadoExito) {
              HapticFeedback.heavyImpact(); // Vibración contundente de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('¡Sesión completada y guardada! 🚀', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.black87,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
                ),
              );
              context.read<PomodoroBloc>().add(const SeleccionarTareaPomodoro(tareaId: null, tituloTarea: null));
            }
          },
          builder: (context, state) {
            final bloc = context.read<PomodoroBloc>();
            final tituloTareaActiva = bloc.tituloTareaSeleccionada;

            int segundosAMostrar = 1500;
            bool estaCorriendo = false;
            bool estaPausado = false;

            if (state is PomodoroRunning) {
              segundosAMostrar = state.segundosRestantes;
              estaCorriendo = true;
            } else if (state is PomodoroPaused) {
              segundosAMostrar = state.segundosRestantes;
              estaPausado = true;
            } else if (state is PomodoroGuardando) {
              return const Center(child: CircularProgressIndicator(color: ThemeLumind.textoPrincipal));
            }

            // Calculamos cuánto anillo dibujar (basado en 25 mins)
            double progreso = segundosAMostrar / 1500;

            return Center(
              child: SingleChildScrollView( // <-- ESTA ES LA MAGIA ANTI-OVERFLOW
                physics: const BouncingScrollPhysics(), // Scroll suave estilo Apple
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24), // Margen superior añadido por seguridad
                    const Text(
                      'ENFOQUE',
                      style: TextStyle(fontSize: 14, letterSpacing: 4.0, fontWeight: FontWeight.w600, color: Colors.black38),
                    ),
                    const SizedBox(height: 12),
                    
                    if (tituloTareaActiva != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: ThemeLumind.acento.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🎯 $tituloTareaActiva',
                          style: const TextStyle(color: ThemeLumind.acento, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // EL NUEVO ANILLO DE ENFOQUE PREMIUM
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 260, // Ligeramente más pequeño para que respire mejor en Mac
                          height: 260,
                          child: CircularProgressIndicator(
                            value: progreso,
                            strokeWidth: 6,
                            backgroundColor: Colors.black.withValues(alpha: 0.04),
                            color: ThemeLumind.acento,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          _formatearTiempo(segundosAMostrar),
                          style: const TextStyle(
                            fontSize: 76, // Ajustado al nuevo tamaño del anillo
                            fontWeight: FontWeight.w200,
                            color: ThemeLumind.textoPrincipal,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40), // Reducido un pelín el espacio
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!estaCorriendo && !estaPausado)
                          _BotonControl(
                            icono: Icons.play_arrow_rounded,
                            color: ThemeLumind.acento,
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.read<PomodoroBloc>().add(const IniciarPomodoro(minutos: 25));
                            },
                          ),
                        if (estaCorriendo)
                          _BotonControl(
                            icono: Icons.pause_rounded,
                            color: ThemeLumind.textoPrincipal,
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.read<PomodoroBloc>().add(PausarPomodoro());
                            },
                          ),
                        if (estaPausado) ...[
                          _BotonControl(
                            icono: Icons.play_arrow_rounded,
                            color: ThemeLumind.acento,
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.read<PomodoroBloc>().add(ReanudarPomodoro());
                            },
                          ),
                          const SizedBox(width: 24),
                          _BotonControl(
                            icono: Icons.stop_rounded,
                            color: Colors.black26,
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.read<PomodoroBloc>().add(ResetearPomodoro());
                            },
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 16), 
                    if (!estaCorriendo && !estaPausado)
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.read<PomodoroBloc>().add(const IniciarPomodoro(minutos: 1));
                        },
                        child: const Text('Test rápido (1 min)', style: TextStyle(color: Colors.black26)),
                      ),
                    const SizedBox(height: 100), // Espacio extra abajo para que el Dock no lo tape
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// LA FÁBRICA DE BOTONES RESTAURADA
class _BotonControl extends StatelessWidget {
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  const _BotonControl({required this.icono, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeLumind.superficie,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icono, size: 40, color: color),
      ),
    );
  }
}