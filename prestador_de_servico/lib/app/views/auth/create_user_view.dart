import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/create_user_viewmodel.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/auth/states/create_user_state.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_second_sign_in_header.dart';
import 'package:provider/provider.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  late CreateUserViewModel createUserViewModel;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeSurname = FocusNode();
  final FocusNode focusNodePhone = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();

  final CustomNotifications notifications = CustomNotifications();

  @override
  void initState() {
    createUserViewModel = CreateUserViewModel(authService: context.read<AuthService>());
    super.initState();
  }

  @override
  void dispose() {
    createUserViewModel.dispose();
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    focusNodeName.dispose();
    focusNodeSurname.dispose();
    focusNodePhone.dispose();
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
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
                        child: CustomSecondSignInHeader(title: 'Criar\nConta'),
                      ),
                      BackNavigation(onTap: backNavigation),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: ListenableBuilder(
                      listenable: createUserViewModel,
                      builder: (context, _) {
                        bool createUserLoading = createUserViewModel.state is LoadingUserCreation;

                        if (createUserViewModel.state is UserCreated) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            notifications.showSuccessAlert(
                              context: context,
                              title: 'Usuário Cadastrado',
                              content:
                                  'Faça a confirmação de sua conta através do link enviado para o seu email.',
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

                        if (createUserViewModel.state is ErrorUserCreation) {
                          final errorState = (createUserViewModel.state as ErrorUserCreation);
                          nameMessage = errorState.nameMessage;
                          surnameMessage = errorState.surnameMessage;
                          phoneMessage = errorState.phoneMessage;
                          emailMessage = errorState.emailMessage;
                          passwordMessage = errorState.passwordMessage;
                          confirmPasswordMessage = errorState.confirmPasswordMessage;
                          genericMessage = errorState.genericMessage;
                          if (genericMessage != null) {
                            genericErrorWidget = CustomTextError(message: genericMessage);
                          }
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextField(
                              label: 'Nome',
                              controller: nameController,
                              focusNode: focusNodeName,
                              errorMessage: nameMessage,
                            ),
                            const SizedBox(height: 18),
                            CustomTextField(
                              label: 'Sobrenome',
                              controller: surnameController,
                              focusNode: focusNodeSurname,
                              errorMessage: surnameMessage,
                            ),
                            const SizedBox(height: 18),
                            CustomTextField(
                              label: 'Telefone',
                              controller: phoneController,
                              focusNode: focusNodePhone,
                              errorMessage: phoneMessage,
                            ),
                            const SizedBox(height: 18),
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
                            CustomTextField(
                              label: 'Confirmação de senha',
                              controller: confirmPasswordController,
                              focusNode: focusNodeConfirmPassword,
                              isPassword: true,
                              errorMessage: confirmPasswordMessage,
                            ),
                            genericErrorWidget,
                            const SizedBox(height: 32),
                            createUserLoading
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
    User user = User(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    createUserViewModel.createUserEmailPassword(user: user);
  }
}
