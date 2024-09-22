import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/create_user/create_user_controller.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/states/create_user/create_user_state.dart';
import 'package:prestador_de_servico/app/views/create_user/widgets/create_account_header.dart';
import 'package:provider/provider.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
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
  void initState() {
    context.read<CreateUserController>().init();
    super.initState();
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
                        child: CreateAccountHeader(title: 'Criar\nCnta'),
                      ),
                      BackNavigation(onTap: backNavigation),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Consumer<CreateUserController>(
                      builder: (context, createAccountController, _) {
                    bool createAccountSent =
                        createAccountController.state is CreateUserSent;

                    if (createAccountController.state is UserCreated) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _notifications.showSnackBar(
                          context: context,
                          message: 'Usuário criado',
                        );
                      }); 

                      Navigator.pop(context);
                    }

                    Widget genericErrorWidget = const SizedBox(height: 18);
                    String? nameMessage;
                    String? surnameMessage;
                    String? phoneMessage;
                    String? emailMessage;
                    String? passwordMessage;
                    String? confirmPasswordMessage;
                    String? genericMessage;

                    if (createAccountController.state is ErrorCreatingUser) {
                      nameMessage =
                          (createAccountController.state as ErrorCreatingUser)
                              .nameMessage;
                      surnameMessage =
                          (createAccountController.state as ErrorCreatingUser)
                              .surnameMessage;
                      phoneMessage =
                          (createAccountController.state as ErrorCreatingUser)
                              .phoneMessage;
                      emailMessage =
                          (createAccountController.state as ErrorCreatingUser)
                              .emailMessage;
                      passwordMessage =
                          (createAccountController.state as ErrorCreatingUser)
                              .passwordMessage;
                      genericMessage =
                          (createAccountController.state as ErrorCreatingUser)
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
    context.read<CreateUserController>().createAccountWithEmailAndPassword(
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        );
  } 

  void finishRegister() { 
    
  }
}
