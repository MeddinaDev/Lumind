import 'package:equatable/equatable.dart';

abstract class UsuarioEvent extends Equatable {
  const UsuarioEvent();

  @override
  List<Object> get props => [];
}

class CrearNuevoUsuario extends UsuarioEvent {
  final String nombre;

  const CrearNuevoUsuario(this.nombre);

  @override
  List<Object> get props => [nombre];
}