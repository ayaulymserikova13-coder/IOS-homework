import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    if (isClosed || state is AuthLoading) return;
    emit(const AuthLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      // The provider may be disposed while the simulated request is pending.
      if (isClosed) return;
      final address = email.trim();
      if (address.isEmpty || password.isEmpty) {
        emit(const AuthError('Please enter your email and password.'));
      } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(address)) {
        emit(const AuthError('Please enter a valid email address.'));
      } else if (address == 'student@narxoz.kz' && password == '123456') {
        emit(AuthSuccess('Student', address));
      } else {
        emit(const AuthError('Incorrect email or password. Please try again.'));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthError('Unable to sign in. Please try again.'));
      }
    }
  }
}
