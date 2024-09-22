import 'package:flutter/material.dart';

class CustomTextError extends StatelessWidget {
  final String message;

  const CustomTextError({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 10),
      child: Text(
        message,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
