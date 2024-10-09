import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';
import 'package:prestador_de_servico/app/controllers/auth/login_controller.dart';
import 'package:prestador_de_servico/app/states/auth/login_state.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/login_google_button.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_login_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/register_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                    child: const CustomLoginHeader(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 500,
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Consumer<LoginController>(
                        builder: (context, loginController, _) {
                      if (loginController.state is LoginSent) {
                        return const Center(
                          child: CustomLoading(),
                        );
                      }

                      if (loginController.state is LoginSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _notifications.showSnackBar(
                            context: context,
                            message: 'Usuário autenticado!',
                          );

                          doStart();
                        });
                      }

                      Widget genericErrorWidget = const SizedBox(height: 18);
                      String? emailMessage;
                      String? passwordMessage;
                      String? genericMessage;

                      if (loginController.state is LoginError) {
                        emailMessage =
                            (loginController.state as LoginError).emailMessage;
                        passwordMessage = (loginController.state as LoginError)
                            .passwordMessage;
                        genericMessage = (loginController.state as LoginError)
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
                            onTap: loginWithEmailPassword,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Ou entre com',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          LoginGoogleButton(onTap: () {}),
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

  void loginWithEmailPassword() {
    context.read<LoginController>().loginWithEmailPasswordSent(
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

  void doStart() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/start', (Route<dynamic> route) => false);
  }
}
