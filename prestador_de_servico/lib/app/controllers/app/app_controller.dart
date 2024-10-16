import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';

class AppController extends ChangeNotifier {
  final _syncServiceCategoryService = SyncServiceCategoryService();

  AppController() {
    init();
  }

  AppState _state = LoadingApp();
  AppState get state => _state;

  void _changeState({required AppState currentSignInState}) {
    _state = currentSignInState;
    notifyListeners();
  }

  Future<void> init() async {
    _syncData();

    _changeState(currentSignInState: AppLoaded());
  }

  Future<void> _syncData() async {
    await _syncServiceCategoryService.synchronize();
  }
}
