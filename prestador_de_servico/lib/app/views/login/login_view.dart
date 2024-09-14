import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/login/widgets/login_google_button.dart';
import 'package:prestador_de_servico/app/views/login/widgets/login_header.dart';
import 'package:prestador_de_servico/app/views/login/widgets/register_link.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/login_header.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.8,
                  child: const LoginHeader()
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
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
                      const SizedBox(height: 32),
                      const CustomButton(label: 'Logar'),
                      const SizedBox(height: 20),
                      const Text(
                        'Ou entre com',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const LoginGoogleButton(),
                      const SizedBox(height: 40),
                      const RegisterLink(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
