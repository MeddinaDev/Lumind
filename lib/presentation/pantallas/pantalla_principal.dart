import 'dart:ui';
import 'package:flutter/material.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  // Pantallas de marcador de posición (con un color de fondo sutil para que se note el desenfoque)
  final List<Widget> _pantallas = [
    Container(
      color: const Color(0xFFF5F5F7), // Un gris ultra claro típico de Apple
      child: const Center(child: Text('⏱️ Pantalla del Temporizador', style: TextStyle(fontSize: 18, color: Colors.black54))),
    ),
    Container(
      color: const Color(0xFFF5F5F7),
      child: const Center(child: Text('📝 Pantalla de Tareas', style: TextStyle(fontSize: 18, color: Colors.black54))),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Esto permite que el fondo pase por DEBAJO de la barra de navegación
      extendBody: true, 
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          // Separamos la barra de los bordes para que flote como un Dock
          margin: const EdgeInsets.only(left: 32, right: 32, bottom: 16), 
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
            child: BackdropFilter(
              // El desenfoque matemático del cristal
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), 
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6), // Blanco translúcido
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), // Borde brillante sutil
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
                  backgroundColor: Colors.transparent, // Fondo transparente a
                  elevation: 0, // Cero sombras rígidas
                  selectedItemColor: Colors.blueAccent,
                  unselectedItemColor: Colors.grey.shade500,
                  showSelectedLabels: false, // Ocultamos textos para un look más limpio
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