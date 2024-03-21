import 'package:chatapp/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          Navigator.of(context).pop();
        } else if (!state.isValid) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SignUpInput(),
              // const SizedBox(height: 8),
              // _PasswordInput(),
              // const SizedBox(height: 8),
              // _ConfirmPasswordInput(),
              // const SizedBox(height: 8),
              // _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}
