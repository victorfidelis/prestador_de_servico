import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/app/app_service.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';

class AppController extends ChangeNotifier {
  final AppService _appService;
  
  AppController({required AppService appService}) : _appService = appService {
    init();
  }

  AppState _state = LoadingApp();
  AppState get state => _state;

  void _changeState({required AppState currentLoginState}) {
    _state = currentLoginState;
    notifyListeners();
  }

  Future<void> init() async {
    await _appService.initializeApp();
    _changeState(currentLoginState: AppLoaded());
  }
}
