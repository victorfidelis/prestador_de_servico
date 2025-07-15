import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/login_viewmodel.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/sign_in_google_button.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_sign_in_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/register_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/wrapper/viewmodel/wrapper_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel loginViewModel;

  @override
  void initState() {
    loginViewModel = LoginViewModel(
      authService: context.read<AuthService>(),
    );
    
    loginViewModel.editSuccessful.addListener(() {
      if (loginViewModel.editSuccessful.value) {
        context.read<WrapperViewModel>().logIn(loginViewModel.user!);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    loginViewModel.dispose();
    super.dispose();
  }

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
                  child: const CustomSignInHeader(),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 700,
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: ListenableBuilder(
                    listenable: loginViewModel,
                    builder: (context, _) {
                      if (loginViewModel.isLoginLoading) {
                        return const Center(
                          child: CustomLoading(),
                        );
                      }

                      Widget genericErrorWidget = const SizedBox(height: 18);
                      if (loginViewModel.genericErrorMessage != null) {
                        genericErrorWidget = CustomTextError(message: loginViewModel.genericErrorMessage!);
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            label: 'Email',
                            controller: loginViewModel.emailController,
                            errorMessage: loginViewModel.emailErrorMessage,
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            label: 'Senha',
                            controller: loginViewModel.passwordController,
                            isPassword: true,
                            errorMessage: loginViewModel.passwordErrorMessage,
                          ),
                          genericErrorWidget,
                          Row(
                            children: [
                              Expanded(child: Container()),
                              CustomLink(
                                label: 'Esqueci a senha',
                                onTap: _doPasswordReset,
                                undeline: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            label: 'Logar',
                            onTap: _signInEmailPassword,
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
                          RegisterLink(onTap: _doCreateAccount),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signInEmailPassword() {
    loginViewModel.signInEmailPassword(
      email: loginViewModel.emailController.text.trim(),
      password: loginViewModel.passwordController.text.trim(),
    );
  }

  void _doCreateAccount() {
    Navigator.pushNamed(context, '/createAccount');
  }

  void _doPasswordReset() {
    Navigator.pushNamed(context, '/passwordReset');
  }
}
