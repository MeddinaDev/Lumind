import 'package:equatable/equatable.dart';

class Tarea extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final bool estaCompletada;
  final DateTime fechaCreacion;
  final String usuarioId;

  const Tarea({
    required this.id,
    required this.titulo,
    this.descripcion = '',
    this.estaCompletada = false,
    required this.fechaCreacion,
    required this.usuarioId,
  });

  // Método puro definido en tu TFG para completar la tarea
  Tarea marcarCompletada() {
    return copyWith(estaCompletada: true);
  }

  // Equivalente al método editar() de tu diagrama de clases
  Tarea copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    bool? estaCompletada,
    DateTime? fechaCreacion,
    String? usuarioId,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estaCompletada: estaCompletada ?? this.estaCompletada,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titulo,
        descripcion,
        estaCompletada,
        fechaCreacion,
        usuarioId,
      ];
}