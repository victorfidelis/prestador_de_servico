import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/login/login_state.dart';
import 'package:prestador_de_servico/firebase_options.dart';

class LoginProvider extends ChangeNotifier {
  
  LoginState loginState = LoadingAplication();

  LoginProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    loginState = PendingLogin();
    notifyListeners();
  }
}
