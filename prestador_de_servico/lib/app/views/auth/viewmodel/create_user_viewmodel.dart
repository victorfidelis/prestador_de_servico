import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class CreateUserViewModel extends ChangeNotifier {
  final AuthService authService;
  bool isCreateUserLoading = false;
  bool userCreated = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? nameErrorMessage;
  String? surnameErrorMessage;
  String? phoneErrorMessage;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? confirmPasswordErrorMessage;
  String? genericErrorMessage;

  CreateUserViewModel({required this.authService});
  
  void _setCreateUserLoading(bool value) {
    isCreateUserLoading = value;
    notifyListeners();
  }

  Future<void> createUserEmailPassword() async {
    _clearError();
    if (!_validateCreateUserEmailPassword()) {
      notifyListeners();
      return;
    }

    _setCreateUserLoading(true);

    final user = User(
      email: emailController.text,
      name: nameController.text,
      surname: surnameController.text,
      phone: phoneController.text
      );

    final createUserEither = await authService.createUserEmailPassword(user: user, password: passwordController.text);

    if (createUserEither.isLeft) {
      genericErrorMessage = createUserEither.left!.message;
    } else {
      userCreated = true;
    }

    notifyListeners();
  }

  bool _validateCreateUserEmailPassword() {
    bool isValid = true;

    nameController.text = nameController.text.trim();
    surnameController.text = surnameController.text.trim();
    emailController.text = emailController.text.trim();
    passwordController.text = passwordController.text.trim();
    confirmPasswordController.text = confirmPasswordController.text.trim();
    passwordController.text = passwordController.text.trim();

    if (nameController.text.isEmpty) {
      nameErrorMessage = 'Necessário informar o nome';
      isValid = false;
    }
    if (surnameController.text.isEmpty) {
      surnameErrorMessage = 'Necessário informar o sobrenome';
      isValid = false;
    }
    if (emailController.text.isEmpty) {
      emailErrorMessage = 'Necessário informar o email';
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordErrorMessage = 'Necessário informar a senha';
      isValid = false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordErrorMessage = 'Necessário informar a confirmação da senha';
      isValid = false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      passwordErrorMessage = 'Senha incompatível';
      isValid = false;
    }

    return isValid;
  } 

  void _clearError() {
    nameErrorMessage = null;
    surnameErrorMessage = null;
    emailErrorMessage = null;
    passwordErrorMessage = null;
    confirmPasswordErrorMessage = null;
    passwordErrorMessage = null;
  }
}
