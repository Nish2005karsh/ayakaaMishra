import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await _repo.driverLogin(event.mobile);
      if (result.status.isSuccess && result.userId > 0) {
        emit(AuthOtpSent(userId: result.userId, mobile: event.mobile));
      } else {
        emit(AuthError(result.status.message));
      }
    } catch (e) {
      debugPrint('AuthBloc LoginSubmitted error: $e');
      emit(AuthError('Network error. Please check your connection.'));
    }
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await _repo.verifyOtp(event.userId, event.otp);
      if (result.status.isSuccess && result.driver != null) {
        emit(AuthAuthenticated(
          driver: result.driver!,
          profilePhoto: result.profilePhoto,
        ));
      } else {
        emit(AuthError(result.status.message));
      }
    } catch (e) {
      debugPrint('AuthBloc OtpSubmitted error: $e');
      emit(AuthError('Network error. Please check your connection.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repo.logout();
    emit(const AuthUnauthenticated());
  }
}
