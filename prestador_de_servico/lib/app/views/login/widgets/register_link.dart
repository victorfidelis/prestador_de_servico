import 'package:flutter/material.dart';

class RegisterLink extends StatelessWidget {
  const RegisterLink({super.key});

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
          child: const Text(
            'Cadastre-se',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xff0E293C),
            ),
          ),
        )
      ],
    );
  }
}
