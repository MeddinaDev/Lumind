import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.nombre,
    super.nivelActual,
    super.puntosTotal,
  });

  // Traductor: De Supabase a la App
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nombre: json['nombre'],
      nivelActual: json['nivel'] ?? 1,
      puntosTotal: json['puntos_total'] ?? 0,
    );
  }

  // Traductor: De la App a Supabase
  Map<String, dynamic> toJson() {
    return {
      // Nota: No enviamos el 'id' porque hemos configurado Supabase para que genere el UUID automáticamente.
      'nombre': nombre,
      'nivel': nivelActual,
      'puntos_total': puntosTotal,
    };
  }
}