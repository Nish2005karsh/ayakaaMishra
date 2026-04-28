import 'package:equatable/equatable.dart';
import '../../model/driver_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

// driver_login succeeded — OTP was sent
class AuthOtpSent extends AuthState {
  final int userId;
  final String mobile;
  const AuthOtpSent({required this.userId, required this.mobile});
  @override
  List<Object?> get props => [userId, mobile];
}

// verify_otp succeeded — fully authenticated
class AuthAuthenticated extends AuthState {
  final DriverModel driver;
  final String profilePhoto;
  const AuthAuthenticated({required this.driver, required this.profilePhoto});
  @override
  List<Object?> get props => [driver.dId];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
