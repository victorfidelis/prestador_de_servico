import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';
import 'package:prestador_de_servico/app/controllers/auth/sign_in_controller.dart';
import 'package:prestador_de_servico/app/states/auth/sign_in_state.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/sign_in_google_button.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_sign_in_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/register_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final CustomNotifications _notifications = CustomNotifications();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppController>(builder: (context, appController, _) {
        if (appController.state is LoadingApp) {
          return const Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SingleChildScrollView(
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
                    child: const CustomSignInHeader(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 500,
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Consumer<SignInController>(
                        builder: (context, signInController, _) {
                      if (signInController.state is LoadingSignIn) {
                        return const Center(
                          child: CustomLoading(),
                        );
                      }

                      if (signInController.state is SignInSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _notifications.showSnackBar(
                            context: context,
                            message: 'Usuário autenticado!',
                          );

                          doMainView();
                        });
                      }

                      Widget genericErrorWidget = const SizedBox(height: 18);
                      String? emailMessage;
                      String? passwordMessage;
                      String? genericMessage;

                      if (signInController.state is SignInError) {
                        emailMessage =
                            (signInController.state as SignInError).emailMessage;
                        passwordMessage = (signInController.state as SignInError)
                            .passwordMessage;
                        genericMessage = (signInController.state as SignInError)
                            .genericMessage;
                        if (genericMessage != null) {
                          genericErrorWidget =
                              CustomTextError(message: genericMessage);
                        }
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            label: 'Email',
                            controller: _emailController,
                            focusNode: _focusNodeEmail,
                            errorMessage: emailMessage,
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            label: 'Senha',
                            controller: _passwordController,
                            focusNode: _focusNodePassword,
                            isPassword: true,
                            errorMessage: passwordMessage,
                          ),
                          genericErrorWidget,
                          Row(
                            children: [
                              Expanded(child: Container()),
                              CustomLink(
                                label: 'Esqueci a senha',
                                onTap: doPasswordReset,
                                undeline: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            label: 'Logar',
                            onTap: signInEmailPassword,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Ou entre com',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SignInGoogleButton(onTap: () {}),
                          const SizedBox(height: 40),
                          RegisterLink(onTap: doCreateAccount),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void signInEmailPassword() {
    context.read<SignInController>().signInEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  void doCreateAccount() {
    context.read<CreateUserController>().init();
    Navigator.pushNamed(context, '/createAccount');
  }

  void doPasswordReset() {
    context.read<PasswordResetController>().init();
    Navigator.pushNamed(context, '/passwordReset');
  }

  void doMainView() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/navigation', (Route<dynamic> route) => false);
  }
}
