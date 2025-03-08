import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
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
  late final PasswordResetViewModel passwordResetViewModel;

  final TextEditingController emailController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();

  @override
  void initState() {
    passwordResetViewModel = PasswordResetViewModel(authService: context.read<AuthService>());
    super.initState();
  }

  @override
  void dispose() {
    passwordResetViewModel.dispose();
    emailController.dispose();
    focusNodeEmail.dispose();
    super.dispose();
  }

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
                  child: ListenableBuilder(
                      listenable: passwordResetViewModel,
                      builder: (context, _) {
                        String? emailMessage;

                        if (passwordResetViewModel.state is ErrorPasswordResetEmail) {
                          emailMessage =
                              (passwordResetViewModel.state as ErrorPasswordResetEmail).message;
                        } else if (passwordResetViewModel.state is PasswordResetEmailSentSuccess) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 100),
                              const Text('Email para redefinição de senha enviado!'),
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
                                controller: emailController,
                                focusNode: focusNodeEmail,
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
    passwordResetViewModel.sendPasswordResetEmail(
      email: emailController.text.trim().toLowerCase(),
    );
  }
}
