import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String mobile;
  const LoginSubmitted(this.mobile);
  @override
  List<Object?> get props => [mobile];
}

class OtpSubmitted extends AuthEvent {
  final int userId;
  final String otp;
  const OtpSubmitted({required this.userId, required this.otp});
  @override
  List<Object?> get props => [userId, otp];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
