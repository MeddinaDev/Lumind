import 'package:equatable/equatable.dart';
import '../../../domain/entities/usuario.dart';

abstract class UsuarioState extends Equatable {
  const UsuarioState();
  
  @override
  List<Object> get props => [];
}

class UsuarioInitial extends UsuarioState {}

class UsuarioLoading extends UsuarioState {}

class UsuarioLoaded extends UsuarioState {
  final Usuario usuario;

  const UsuarioLoaded(this.usuario);

  @override
  List<Object> get props => [usuario];
}

class UsuarioError extends UsuarioState {
  final String message;

  const UsuarioError(this.message);

  @override
  List<Object> get props => [message];
}