import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/view/widget/custom_button.dart';
import 'package:prestador_de_servico/app/view/widget/custom_link.dart';
import 'package:prestador_de_servico/app/view/widget/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Email',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: 'Senha',
                isPassword: true,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: Container()),
                  CustomLink(
                    label: 'Esqueci a senha',
                    undeline: true,
                  ),
                ],
              ),
              const SizedBox(height: 38),
              CustomButton(
                label: 'Logar'
              )
            ],
          ),
        ),
      ),
    );
  }
}
