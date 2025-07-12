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
            'Usuário criado com sucesso!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Agora basta acessar seu email e confirmar sua conta antes do primeiro login',
            style: TextStyle(
              fontSize: 16,
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
