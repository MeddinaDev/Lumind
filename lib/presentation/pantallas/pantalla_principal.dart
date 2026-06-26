import 'dart:ui';
import 'package:flutter/material.dart';
import 'temporizador/pantalla_temporizador.dart';
import 'tareas/pantalla_tareas.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  final List<Widget> _pantallas = [
    const PantallaTemporizador(),
    const PantallaTareas(), // Aquí está conectada correctamente
    Container(
      color: const Color(0xFFF5F5F7),
      child: const Center(child: Text('📝 Pantalla de Tareas', style: TextStyle(fontSize: 18, color: Colors.black54))),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
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
                  selectedItemColor: Colors.blueAccent,
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