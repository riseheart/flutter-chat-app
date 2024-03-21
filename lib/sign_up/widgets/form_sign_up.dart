import 'package:chatapp/animation/animation.dart';
import 'package:chatapp/sign_up/sign_up.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpInput extends StatefulWidget {
  const SignUpInput({super.key});

  @override
  State<SignUpInput> createState() => _SignUpInputState();
}

class _SignUpInputState extends State<SignUpInput> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  late FocusNode _usernameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _rePasswordFocusNode;

  bool _passwordVisible = false;
  bool _rePasswordVisible = false;
  bool _isPasswordSixCharacters = false;
  bool _isPasswordRule = false;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _rePasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();

    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _rePasswordFocusNode.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]+$');

    setState(() {
      _isPasswordSixCharacters = false;
      if (password.length >= 6) _isPasswordSixCharacters = true;

      _isPasswordRule = false;
      if (passwordRegex.hasMatch(password)) _isPasswordRule = true;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleRePasswordVisibility() {
    setState(() {
      _rePasswordVisible = !_rePasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInSlide(
            duration: .3,
            direction: FadeSlideDirection.btt,
            child: CustomTextFormField(
              controller: _usernameController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: _usernameFocusNode,
              onFieldSubmitted: (value) {
                _usernameFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              labelText: 'Username',
              prefixIcon: Icons.person,
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .4,
            direction: FadeSlideDirection.btt,
            child: CustomTextFormField(
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: _emailFocusNode,
              onFieldSubmitted: (value) {
                _emailFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              labelText: 'Email',
              prefixIcon: Icons.email,
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .5,
            direction: FadeSlideDirection.btt,
            child: CustomTextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              focusNode: _passwordFocusNode,
              onFieldSubmitted: (value) {
                _passwordFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_rePasswordFocusNode);
              },
              onChanged: (password) => _onPasswordChanged(password),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              isPasswordField: _togglePasswordVisibility,
              labelText: 'Password',
              prefixIcon: Icons.lock,
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .6,
            direction: FadeSlideDirection.btt,
            child: CustomTextFormField(
              controller: _rePasswordController,
              obscureText: !_rePasswordVisible,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              focusNode: _rePasswordFocusNode,
              onFieldSubmitted: (value) {
                _rePasswordFocusNode.unfocus();
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value != _passwordController.text) {
                  return 'Not match';
                }
                return null;
              },
              isPasswordField: _toggleRePasswordVisibility,
              labelText: 'Confirm Password',
              prefixIcon: Icons.lock,
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .7,
            direction: FadeSlideDirection.btt,
            child: CheckInput(
              condition: _isPasswordSixCharacters,
              conditionText: 'Contains at least 6 characters',
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .8,
            direction: FadeSlideDirection.btt,
            child: CheckInput(
              condition: _isPasswordRule,
              conditionText:
                  'Contains at least 1 number, 1 lowercase letter, 1 uppercase letter and 1 special character.',
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .9,
            direction: FadeSlideDirection.btt,
            child: Center(
              child: BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return state.status == SignUpStatus.inProgress
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              if (/*_onPasswordChanged(_passwordController.text)*/ true) {
                                context.read<SignUpCubit>().inputSubmited(
                                      _usernameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                context
                                    .read<SignUpCubit>()
                                    .signUpFormSubmitted();
                              }
                            }
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
