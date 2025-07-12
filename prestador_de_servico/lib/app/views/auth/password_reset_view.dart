import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/password_reset_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_second_sign_in_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/password_reset_success.dart';
import 'package:provider/provider.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({super.key});

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  late final PasswordResetViewModel passwordResetViewModel;

  @override
  void initState() {
    passwordResetViewModel = PasswordResetViewModel(authService: context.read<AuthService>());
    super.initState();
  }

  @override
  void dispose() {
    passwordResetViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/header_creation.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                children: [
                  const CustomSecondSignInHeader(title: 'Recuperação\nde senha'),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: ListenableBuilder(
                      listenable: passwordResetViewModel,
                      builder: (context, _) {
                        if (passwordResetViewModel.emailSentSuccess) {
                          return const PasswordResetSuccess();
                        }

                        Widget genericErrorWidget = const SizedBox(height: 18);
                        if (passwordResetViewModel.genericErrorMessage != null) {
                          genericErrorWidget = CustomTextError(message: passwordResetViewModel.genericErrorMessage!);
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
                                controller: passwordResetViewModel.emailController,
                                errorMessage: passwordResetViewModel.emailErrorMessage,
                              ),
                              genericErrorWidget,
                              const SizedBox(height: 30),
                              passwordResetViewModel.isEmailSentLoading
                                  ? const Center(child: CustomLoading())
                                  : CustomButton(
                                      label: 'Enviar Link',
                                      onTap: passwordResetViewModel.sendPasswordResetEmail,
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
