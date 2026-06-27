import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PantallaEstadisticas extends StatefulWidget {
  const PantallaEstadisticas({super.key});

  @override
  State<PantallaEstadisticas> createState() => _PantallaEstadisticasState();
}

class _PantallaEstadisticasState extends State<PantallaEstadisticas> {
  final _usuarioId = Supabase.instance.client.auth.currentUser!.id;
  final _supabase = Supabase.instance.client;

  // Hacemos una consulta rápida a Supabase para sumar todo el progreso
  Future<Map<String, dynamic>> _obtenerEstadisticas() async {
    final respuesta = await _supabase
        .from('sesion_pomodoro')
        .select('duracion_minutos, puntos_ganados')
        .eq('usuario_id', _usuarioId);

    int totalMinutos = 0;
    int totalPuntos = 0;
    int totalSesiones = respuesta.length;

    for (var sesion in respuesta) {
      totalMinutos += (sesion['duracion_minutos'] as num?)?.toInt() ?? 0;
      totalPuntos += (sesion['puntos_ganados'] as num?)?.toInt() ?? 0;
    }

    return {
      'minutos': totalMinutos,
      'puntos': totalPuntos,
      'sesiones': totalSesiones,
    };
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
                'MI PROGRESO',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _obtenerEstadisticas(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.black87));
                    }
                    
                    if (snapshot.hasError) {
                      return Center(child: Text('Error al cargar datos: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                    }

                    final stats = snapshot.data ?? {'minutos': 0, 'puntos': 0, 'sesiones': 0};

                    return ListView(
                      children: [
                        _TarjetaEstadistica(
                          titulo: 'MINUTOS DE ENFOQUE',
                          valor: '${stats['minutos']}',
                          icono: Icons.local_fire_department_rounded,
                          colorIcono: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 16),
                        _TarjetaEstadistica(
                          titulo: 'PUNTOS LUMIND',
                          valor: '${stats['puntos']}',
                          icono: Icons.stars_rounded,
                          colorIcono: Colors.blueAccent,
                        ),
                        const SizedBox(height: 16),
                        _TarjetaEstadistica(
                          titulo: 'SESIONES COMPLETADAS',
                          valor: '${stats['sesiones']}',
                          icono: Icons.check_circle_outline_rounded,
                          colorIcono: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 100), // Espacio para la barra de navegación flotante
            ],
          ),
        ),
      ),
    );
  }
}

// Un widget auxiliar para que las tarjetas queden inmaculadas
class _TarjetaEstadistica extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color colorIcono;

  const _TarjetaEstadistica({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorIcono.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: colorIcono, size: 32),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(fontSize: 12, letterSpacing: 2.0, fontWeight: FontWeight.w600, color: Colors.black38),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}