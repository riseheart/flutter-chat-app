part of 'login_cubit.dart';

enum LoginStatus { initial, failure, inProgress, success }

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.errorMessage,
    required this.status,
  });

  final String email;
  final String password;
  final bool isValid;
  final String? errorMessage;
  final LoginStatus status;

  @override
  List<Object?> get props => [
        email,
        password,
        isValid,
        errorMessage,
        status,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    bool? isValid,
    String? errorMessage,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
      status: status ?? this.status,
    );
  }
}
