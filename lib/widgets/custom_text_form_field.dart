import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {required this.controller,
      this.obscureText = false,
      required this.textInputType,
      required this.textInputAction,
      required this.focusNode,
      this.onFieldSubmitted,
      this.onChanged,
      this.validator,
      super.key,
      required this.labelText,
      required this.prefixIcon,
      this.isPasswordField});
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String labelText;
  final IconData prefixIcon;
  final void Function()? isPasswordField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: isPasswordField != null
            ? IconButton(
                onPressed: isPasswordField,
                icon: obscureText
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.black,
                      ),
              )
            : null,
        filled: true,
        fillColor: Colors.blueGrey.withOpacity(.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }
}
