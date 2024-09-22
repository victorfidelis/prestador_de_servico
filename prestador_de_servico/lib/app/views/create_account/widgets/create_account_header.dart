import 'package:flutter/material.dart';

class CreateAccountHeader extends StatelessWidget {
  const CreateAccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Criar\nConta',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
