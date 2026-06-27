import 'dart:ui';
import 'package:flutter/material.dart';
import 'temporizador/pantalla_temporizador.dart';
import 'tareas/pantalla_tareas.dart';
import 'estadisticas/pantalla_estadisticas.dart';
import '../theme_lumind.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  // Lista limpia solo con las 3 pantallas reales de tu app
  final List<Widget> _pantallas = [
    const PantallaTemporizador(),
    const PantallaTareas(),
    const PantallaEstadisticas(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      // Aquí está la magia de la transición fluida de iOS
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350), 
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: SizedBox(
          key: ValueKey<int>(_indiceActual),
          child: _pantallas[_indiceActual],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 32, right: 32, bottom: 16), 
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), 
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: _indiceActual,
                  onTap: (int index) {
                    setState(() {
                      _indiceActual = index;
                    });
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: ThemeLumind.acento,
                  unselectedItemColor: Colors.grey.shade500,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Icon(Icons.timer_outlined, size: 28),
                      ),
                      activeIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Icon(Icons.timer, size: 28),
                      ),
                      label: 'Enfoque',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Icon(Icons.check_circle_outline, size: 28),
                      ),
                      activeIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Icon(Icons.check_circle, size: 28),
                      ),
                      label: 'Tareas',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Icon(Icons.bar_chart_outlined, size: 28)),
                      activeIcon: Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Icon(Icons.bar_chart_rounded, size: 28)),
                      label: 'Progreso',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}