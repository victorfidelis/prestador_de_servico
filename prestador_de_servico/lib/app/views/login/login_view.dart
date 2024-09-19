import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/app/app_controller.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';
import 'package:prestador_de_servico/app/controllers/login/login_controller.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';
import 'package:prestador_de_servico/app/views/login/widgets/login_google_button.dart';
import 'package:prestador_de_servico/app/views/login/widgets/login_header.dart';
import 'package:prestador_de_servico/app/views/login/widgets/register_link.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();

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
                    child: const LoginHeader(),
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
                        return const Center(
                          child: Text('Usuário logado'),
                        );
                      }

                      String? emailMessage;
                      String? passwordMessage;

                      if (loginController.state is LoginError) {
                        emailMessage =
                            (loginController.state as LoginError).emailMessage;
                        passwordMessage = (loginController.state as LoginError)
                            .passwordMessage;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            label: 'Email',
                            controller: emailController,
                            focusNode: focusNodeEmail,
                            errorMessage: emailMessage,
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            label: 'Senha',
                            controller: passwordController,
                            focusNode: focusNodePassword,
                            isPassword: true,
                            errorMessage: passwordMessage,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              const CustomLink(
                                label: 'Esqueci a senha',
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
                          const LoginGoogleButton(),
                          const SizedBox(height: 40),
                          const RegisterLink(),
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
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }
}
