import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : super(const LoginState(status: LoginStatus.initial));

  final AuthenticationRepository _authenticationRepository;

  void inputSubmited(String emailValue, String passwordValue) {
    final email = emailValue.trim();
    final password = passwordValue.trim();
    final isValid = _isValidEmail(email) && _isValidPassword(password);
    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: isValid,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          isValid: false,
          errorMessage: e.message,
          status: LoginStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(
        isValid: false,
        errorMessage: 'Unexpected error occurred.',
        status: LoginStatus.failure,
      ));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          isValid: false,
          errorMessage: e.message,
          status: LoginStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(
        isValid: false,
        errorMessage: 'Unexpected error occurred.',
        status: LoginStatus.failure,
      ));
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
