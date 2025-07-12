import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/create_user_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/custom_second_sign_in_header.dart';
import 'package:prestador_de_servico/app/views/auth/widgets/user_created_success.dart';
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
  final CustomNotifications notifications = CustomNotifications();

  @override
  void initState() {
    createUserViewModel = CreateUserViewModel(authService: context.read<AuthService>());
    super.initState();
  }

  @override
  void dispose() {
    createUserViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomSecondSignInHeader(title: 'Criar\nConta'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: ListenableBuilder(
                  listenable: createUserViewModel,
                  builder: (context, _) {
                    if (createUserViewModel.userCreated) {
                      return const UserCreatedSuccess();
                    }
                  
                    Widget genericErrorWidget = const SizedBox(height: 18);
                    if (createUserViewModel.genericErrorMessage != null) {
                      genericErrorWidget = CustomTextError(message: createUserViewModel.genericErrorMessage!);
                    }
                  
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          label: 'Nome',
                          controller: createUserViewModel.nameController,
                          errorMessage: createUserViewModel.nameErrorMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Sobrenome',
                          controller: createUserViewModel.surnameController,
                          errorMessage: createUserViewModel.surnameErrorMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Telefone',
                          controller: createUserViewModel.phoneController,
                          errorMessage: createUserViewModel.phoneErrorMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Email',
                          controller: createUserViewModel.emailController,
                          errorMessage: createUserViewModel.emailErrorMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Senha',
                          controller: createUserViewModel.passwordController,
                          isPassword: true,
                          errorMessage: createUserViewModel.passwordErrorMessage,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Confirmação de senha',
                          controller: createUserViewModel.confirmPasswordController,
                          isPassword: true,
                          errorMessage: createUserViewModel.confirmPasswordErrorMessage,
                        ),
                        genericErrorWidget,
                        const SizedBox(height: 32),
                        createUserViewModel.isCreateUserLoading
                            ? const Center(
                                child: CustomLoading(),
                              )
                            : CustomButton(
                                label: 'Criar',
                                onTap: createUserViewModel.createUserEmailPassword,
                              ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
