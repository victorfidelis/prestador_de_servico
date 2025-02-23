import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/password_reset_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_second_sign_in_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/auth/states/password_reset_state.dart';
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
                        child: CustomSecondSignInHeader(title: 'Recuperação\nde senha'),
                      ),
                      BackNavigation(onTap: backNavigation),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Consumer<PasswordResetViewModel>(
                      builder: (context, passwordResetViewModel, _) {
                    String? emailMessage;

                    if (passwordResetViewModel.state is ErrorPasswordResetEmail) {
                      emailMessage =
                          (passwordResetViewModel.state as ErrorPasswordResetEmail)
                              .message;
                    } else if (passwordResetViewModel.state
                        is PasswordResetEmailSentSuccess) {
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
    context.read<PasswordResetViewModel>().sendPasswordResetEmail(
          email: _emailController.text.trim().toLowerCase(),
        );
  }
}
