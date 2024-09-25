import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
