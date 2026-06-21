import 'dart:math';
import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  final String id;
  final String nombre;
  final int nivelActual;
  final int puntosTotal;

  const Usuario({
    required this.id,
    required this.nombre,
    this.nivelActual = 1,
    this.puntosTotal = 0,
  });

  // Lógica matemática de Gamificación (XP requerida = 100 * (Nivel ^ 1.5))
  int get xpParaSiguienteNivel {
    return (100 * pow(nivelActual, 1.5)).toInt();
  }

  // Método puro para aplicar la subida de XP y nivel
  Usuario ganarXP(int xpGanada) {
    int nuevosPuntos = puntosTotal + xpGanada;
    int nuevoNivel = nivelActual;

    // Bucle para comprobar si la experiencia ganada da para subir de nivel
    // (Incluso si da para subir más de un nivel de golpe)
    while (nuevosPuntos >= (100 * pow(nuevoNivel, 1.5)).toInt()) {
      nuevoNivel++;
    }

    // Retornamos una nueva instancia inmutable (buena práctica en BLOC)
    return Usuario(
      id: id,
      nombre: nombre,
      nivelActual: nuevoNivel,
      puntosTotal: nuevosPuntos,
    );
  }

  @override
  List<Object?> get props => [id, nombre, nivelActual, puntosTotal];
}