import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/create_account/create_account_controller.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/states/create_account/create_accout_state.dart';
import 'package:prestador_de_servico/app/views/create_account/widgets/create_account_header.dart';
import 'package:provider/provider.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeSurname = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  final CustomNotifications _notifications = CustomNotifications();

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
                        child: CreateAccountHeader(),
                      ),
                      BackNavigation(onTap: backNavigation),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Consumer<CreateAccountController>(
                      builder: (context, createAccountController, _) {
                    bool createAccountSent =
                        createAccountController.state is CreateAccountSent;

                    if (createAccountController.state is AccountCreated) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _notifications.showSnackBar(
                          context: context,
                          message: 'Usuário autenticado!',
                        );
                      });
                    }

                    Widget genericErrorWidget = const SizedBox(height: 18);
                    String? nameMessage;
                    String? surnameMessage;
                    String? phoneMessage;
                    String? emailMessage;
                    String? passwordMessage;
                    String? confirmPasswordMessage;
                    String? genericMessage;

                    if (createAccountController.state is ErrorInCreation) {
                      emailMessage =
                          (createAccountController.state as ErrorInCreation)
                              .emailMessage;
                      passwordMessage =
                          (createAccountController.state as ErrorInCreation)
                              .passwordMessage;
                      genericMessage =
                          (createAccountController.state as ErrorInCreation)
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
                          label: 'Nome',
                          controller: _nameController,
                          focusNode: _focusNodeName,
                          errorMessage: nameMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Sobrenome',
                          controller: _surnameController,
                          focusNode: _focusNodeSurname,
                          errorMessage: surnameMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Telefone',
                          controller: _phoneController,
                          focusNode: _focusNodePhone,
                          errorMessage: phoneMessage,
                        ),
                        const SizedBox(height: 18),
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
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Confirmação de senha',
                          controller: _confirmPasswordController,
                          focusNode: _focusNodeConfirmPassword,
                          isPassword: true,
                          errorMessage: confirmPasswordMessage,
                        ),
                        genericErrorWidget,
                        const SizedBox(height: 32),
                        createAccountSent
                            ? const Center(
                                child: CustomLoading(),
                              )
                            : CustomButton(
                                label: 'Criar',
                                onTap: createAccountWithEmailAndPassword,
                              ),
                        const SizedBox(height: 20),
                      ],
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

  void createAccountWithEmailAndPassword() {
    context.read<CreateAccountController>().createAccountWithEmailAndPassword(
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        );
  }
}
