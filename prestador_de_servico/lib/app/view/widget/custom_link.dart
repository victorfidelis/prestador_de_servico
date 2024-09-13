import 'package:flutter/material.dart';

class CustomLink extends StatelessWidget {
  final String label;
  final bool undeline;

  CustomLink({
    super.key,
    required this.label,
    this.undeline = false,
  });

  @override
  Widget build(BuildContext context) {
    TextDecoration textDecoration = TextDecoration.none;
    if (undeline) {
      textDecoration = TextDecoration.underline;
    }

    return Text(
      label,
      style: TextStyle(
        color: const Color(0xff1976D2),
        fontSize: 16,
        decoration: textDecoration,
        decorationColor: const Color(0xff1976D2),
      ),
    );
  }
}
