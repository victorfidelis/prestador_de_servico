import 'package:flutter/material.dart';

class RegisterLink extends StatelessWidget {
  final Function() onTap;

  const RegisterLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Não possui conta? ',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Cadastre-se',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }
}
