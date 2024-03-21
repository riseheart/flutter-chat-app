import 'package:flutter/material.dart';

class CheckInput extends StatelessWidget {
  const CheckInput({
    required this.condition,
    required this.conditionText,
    super.key,
  });
  final bool condition;
  final String conditionText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: condition ? Colors.green : Colors.transparent,
              border: condition
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(50)),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(conditionText))
      ],
    );
  }
}
