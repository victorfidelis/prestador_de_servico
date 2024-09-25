import 'package:flutter/material.dart';

class CustomLink extends StatelessWidget {
  final String label;
  final Function() onTap;
  final bool undeline;

  const CustomLink({
    super.key,
    required this.label,
    required this.onTap,
    this.undeline = false,
  });

  @override
  Widget build(BuildContext context) {
    TextDecoration textDecoration = TextDecoration.none;
    if (undeline) {
      textDecoration = TextDecoration.underline;
    }

    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14,
          decoration: textDecoration,
          decorationColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
