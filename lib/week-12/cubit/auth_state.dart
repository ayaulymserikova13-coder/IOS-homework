import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.username, this.email);
  final String username, email;
  @override
  List<Object> get props => [username, email];
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
