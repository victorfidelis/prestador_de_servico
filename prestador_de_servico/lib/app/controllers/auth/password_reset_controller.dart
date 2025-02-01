import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/auth/password_reset_state.dart';

class PasswordResetController extends ChangeNotifier {
  final AuthService authService;

  PasswordResetState _state = WaitingUserSentEmail();
  PasswordResetState get state => _state;
  void _emitState(PasswordResetState currentState) {
    _state = currentState;
    notifyListeners();
  }

  PasswordResetController({required this.authService});

  void init() {
    _emitState(WaitingUserSentEmail());
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    _emitState(LoadingSentEmail());

    final passwordResetEither =
        await authService.sendPasswordResetEmail(email: email);

    passwordResetEither.fold(
      (error) => _emitState(ErrorPasswordResetEmail(message: error.message)),
      (value) => _emitState(PasswordResetEmailSentSuccess()),
    );
  }
}
