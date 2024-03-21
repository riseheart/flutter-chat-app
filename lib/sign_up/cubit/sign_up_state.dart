part of 'sign_up_cubit.dart';

enum SignUpStatus { initial, failure, inProgress, success }

final class SignUpState extends Equatable {
  const SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.errorMessage,
    required this.status,
  });
  final String username;
  final String email;
  final String password;
  final bool isValid;
  final String? errorMessage;
  final SignUpStatus status;

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        isValid,
        errorMessage,
        status,
      ];

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    bool? isValid,
    String? errorMessage,
    SignUpStatus? status,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
