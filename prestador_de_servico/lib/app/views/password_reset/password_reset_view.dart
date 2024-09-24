import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prestador_de_servico/app/controllers/password_reset/password_reset_controller.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/states/password_reset/password_reset_state.dart';
import 'package:provider/provider.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({super.key});

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/header_creation.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Stack(
                    children: [
                      const Center(
                        child: CustomHeader(title: 'Recuperação\nde senha'),
                      ),
                      BackNavigation(onTap: backNavigation),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Consumer<PasswordResetController>(
                      builder: (context, passwordResetController, _) {
                    String? emailMessage;

                    if (passwordResetController.state is ErrorSentEmail) {
                      emailMessage =
                          (passwordResetController.state as ErrorSentEmail)
                              .emailMessage;
                    } else if (passwordResetController.state
                        is ResetEmailSent) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 100),
                          const Text(
                              'Email para redefinição de senha enviado!'),
                          const SizedBox(height: 30),
                          CustomButton(
                            label: 'Efetuar login',
                            onTap: backNavigation,
                          ),
                        ],
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 100),
                          const Text(
                            'Digite seu e-mail e faça o envio do link de recuperação de senha',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            label: 'Email',
                            controller: _emailController,
                            focusNode: _focusNodeEmail,
                            errorMessage: emailMessage,
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            label: 'Enviar Link',
                            onTap: sendPasswordResetEmail,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void backNavigation() {
    Navigator.pop(context);
  }

  void sendPasswordResetEmail() {
    context.read<PasswordResetController>().sendPasswordResetEmail(
          email: _emailController.text.trim().toLowerCase(),
        );
  }
}
