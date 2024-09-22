import 'package:flutter/material.dart';

class CreateAccountHeader extends StatelessWidget {
  final String title;
  const CreateAccountHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
