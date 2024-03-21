import 'package:chatapp/animation/animation.dart';
import 'package:chatapp/login/login.dart';
import 'package:chatapp/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (!state.isValid) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeInSlide(
                duration: .3,
                child: Image.asset(
                  'assets/app_logo.png',
                  height: 120,
                ),
              ),
              FadeInSlide(
                duration: .4,
                child: Text(
                  "Let's connect with the world!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 4),
              const LoginInput(),
              const SizedBox(height: 16),
              FadeInSlide(
                duration: .9,
                direction: FadeSlideDirection.btt,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInSlide(
                duration: 1,
                child: _GoogleLoginButton(),
              ),
              const SizedBox(height: 8),
              FadeInSlide(
                duration: 1,
                direction: FadeSlideDirection.ttb,
                child: _SignUpButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    this.socialSvg,
    required this.socialName,
    this.socialColor,
    super.key,
  });
  final String? socialSvg;
  final String socialName;
  final Color? socialColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: socialColor ?? Colors.black,
          side: BorderSide(width: 2, color: socialColor ?? Colors.black),
          minimumSize: const Size(200, 50)),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Login with $socialName',
          ),
        ],
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: /*() => context.read<LoginCubit>().logInWithGoogle()*/ null,
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Not a member? '),
        TextButton(
          key: const Key('loginForm_createAccount_flatButton'),
          onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
          child: const Text(
            'CREATE ACCOUNT',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
