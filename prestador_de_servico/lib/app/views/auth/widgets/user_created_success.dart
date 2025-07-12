import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';

class UserCreatedSuccess extends StatelessWidget {
  const UserCreatedSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          const Text(
            'Usuário cadastrado com sucesso!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          CustomButton(label: 'Voltar', onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
