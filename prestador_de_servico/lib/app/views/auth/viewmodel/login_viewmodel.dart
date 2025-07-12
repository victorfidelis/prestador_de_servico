import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool isLoginLoading = false;
  bool isLoginSuccessful = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? genericErrorMessage;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  LoginViewModel({required AuthService authService}) : _authService = authService;

  bool get isError {
    return genericErrorMessage != null || emailErrorMessage != null || passwordErrorMessage != null;
  }

  void _setLoginLoading(bool value) {
    isLoginLoading = value;
    notifyListeners();
  }

  Future<void> signInEmailPassword({
    required String email,
    required String password,
  }) async {
    _clearErrors();
    if (!_validateSignInEmailPassword()) {
      notifyListeners();
      return;
    }
    
    _setLoginLoading(true);
    
    final signInEither = await _authService.signInEmailPasswordAndVerifyEmail(
      email: emailController.text,
      password: passwordController.text,
    );

    if (signInEither.isLeft) {
      genericErrorMessage = signInEither.left!.message;
    } else {
      isLoginSuccessful = true;
    }

    _setLoginLoading(false);
  }

  bool _validateSignInEmailPassword() {
    bool isValid = true;

    emailController.text = emailController.text.trim();
    passwordController.text = passwordController.text.trim();

    if (emailController.text.isEmpty) {
      emailErrorMessage = 'Necessário informar o email';
      isValid = false;
    } else if (passwordController.text.isEmpty) {
      passwordErrorMessage = 'Necessário informar a senha';
      isValid = false;
    }

    return isValid;
  }

  void _clearErrors() {
    genericErrorMessage = null;
    emailErrorMessage = null;
    passwordErrorMessage = null;
  }
}
