import '../../domain/entities/tarea.dart';

class TareaModel extends Tarea {
  const TareaModel({
    required super.id,
    required super.titulo,
    super.descripcion = '',
    super.estaCompletada = false,
    required super.fechaCreacion,
    required super.usuarioId,
  });

  // Traductor: De Supabase (JSON) a nuestra App
  factory TareaModel.fromJson(Map<String, dynamic> json) {
    return TareaModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'] ?? '',
      estaCompletada: json['esta_completada'] ?? false,
      // Supabase devuelve la fecha como un String ('2026-06...'), lo pasamos a DateTime
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      usuarioId: json['usuario_id'],
    );
  }

  // Traductor: De nuestra App a Supabase (JSON)
  Map<String, dynamic> toJson() {
    return {
      // Nota: No enviamos 'id' ni 'fecha_creacion' porque Supabase 
      // los genera automáticamente cuando creamos un nuevo registro.
      'titulo': titulo,
      'descripcion': descripcion,
      'esta_completada': estaCompletada,
      'usuario_id': usuarioId,
    };
  }
}