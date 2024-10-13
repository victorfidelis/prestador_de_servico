import 'package:flutter/material.dart';

class CustomSignInHeader extends StatelessWidget {
  const CustomSignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo_var_1.png',
          width: 40,
        ),
        const SizedBox(height: 32),
        Text(
          'Bem vindo',
          style: TextStyle(
            fontSize: 32,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
