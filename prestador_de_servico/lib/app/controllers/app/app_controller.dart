
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';
import 'package:prestador_de_servico/firebase_options.dart';

class AppController extends ChangeNotifier {
  AppController() {
    init();
  }

  AppState _state = LoadingApp();
  AppState get state => _state;

  void _changeState({required AppState currentLoginState}) {
    _state = currentLoginState;
    notifyListeners();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _changeState(currentLoginState: AppLoaded());
  }
}