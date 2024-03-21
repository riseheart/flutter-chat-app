import 'package:chatapp/animation/animation.dart';
import 'package:chatapp/login/login.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginInput extends StatefulWidget {
  const LoginInput({super.key});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  bool _passwordVisible = false;
  bool _isPasswordSixCharacters = false;
  bool _isPasswordRule = false;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _onPasswordChanged(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]+$');

    setState(() {
      _isPasswordSixCharacters = false;
      if (password.length >= 6) _isPasswordSixCharacters = true;

      _isPasswordRule = false;
      if (passwordRegex.hasMatch(password)) _isPasswordRule = true;
    });
    if (_isPasswordSixCharacters && _isPasswordRule) {
      return true;
    } else {
      return false;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .5,
            child: CustomTextFormField(
              controller: _usernameController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: _usernameFocusNode,
              onFieldSubmitted: (value) {
                _usernameFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              labelText: 'Email',
              prefixIcon: Icons.person,
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .6,
            child: CustomTextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              focusNode: _passwordFocusNode,
              onFieldSubmitted: (value) {
                _passwordFocusNode.unfocus();
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
            duration: .7,
            child: CheckInput(
              condition: _isPasswordSixCharacters,
              conditionText: 'Contains at least 6 characters',
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .7,
            child: CheckInput(
              condition: _isPasswordRule,
              conditionText:
                  'Contains at least 1 number, 1 lowercase letter, 1 uppercase letter and 1 special character.',
            ),
          ),
          const SizedBox(height: 8),
          FadeInSlide(
            duration: .8,
            child: Center(
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return state.status == LoginStatus.inProgress
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
                                context.read<LoginCubit>().inputSubmited(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                                context
                                    .read<LoginCubit>()
                                    .logInWithCredentials();
                              }
                            }
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
