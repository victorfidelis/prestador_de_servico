import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';

class PasswordResetSuccess extends StatelessWidget {
  const PasswordResetSuccess({super.key});

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
            'Email para redefinição de senha enviado!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Agora basta acessar seu email e redefinir sua senha por lá',
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
