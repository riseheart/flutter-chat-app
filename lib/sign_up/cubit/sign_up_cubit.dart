import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository)
      : super(const SignUpState(status: SignUpStatus.initial));

  final AuthenticationRepository _authenticationRepository;

  void inputSubmited(
    String usernameValue,
    String emailValue,
    String passwordValue,
  ) {
    final username = usernameValue;
    final email = emailValue.trim();
    final password = passwordValue.trim();
    final isValid = _isValidEmail(email) && _isValidPassword(password);
    emit(
      state.copyWith(
        username: username,
        email: email,
        password: password,
        isValid: isValid,
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: SignUpStatus.inProgress));
    try {
      await _authenticationRepository.signUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          isValid: false,
          errorMessage: e.message,
          status: SignUpStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(
          isValid: false,
          errorMessage: 'Unexpected error occurred.',
          status: SignUpStatus.failure));
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
