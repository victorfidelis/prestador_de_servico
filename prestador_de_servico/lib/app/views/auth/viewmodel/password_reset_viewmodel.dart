import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class PasswordResetViewModel extends ChangeNotifier {
  final AuthService authService;

  bool isEmailSentLoading = false;
  bool emailSentSuccess = false;

  final TextEditingController emailController = TextEditingController();

  String? emailErrorMessage;
  String? genericErrorMessage;

  PasswordResetViewModel({required this.authService});

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _setEmailSentLoading(bool value) {
    isEmailSentLoading = value;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail() async {
    _clearErrors();
    if (!_validadeSendLink()) {
      notifyListeners();
      return;
    }

    _setEmailSentLoading(true);

    final passwordResetEither = await authService.sendPasswordResetEmail(email: emailController.text);

    if (passwordResetEither.isLeft) {
      genericErrorMessage = passwordResetEither.left!.message;
    } else {
      emailSentSuccess = true;
    }

    _setEmailSentLoading(false);
  }

  bool _validadeSendLink() {
    bool isValid = true;

    emailController.text = emailController.text.trim();

    if (emailController.text.isEmpty) {
      emailErrorMessage = 'Necessário informar o email';
      isValid = false;
    }

    return isValid;
  }

  void _clearErrors() {
    emailErrorMessage = null;
    genericErrorMessage = null;
  }
}
