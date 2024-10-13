import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/app/app_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';

class AppController extends ChangeNotifier {
  final AppService appService;
  late SyncServiceCategoryService _syncServiceCategoryService; 
  
  AppController({required this.appService}) {
    init();
  }

  AppState _state = LoadingApp();
  AppState get state => _state;

  void _changeState({required AppState currentSignInState}) {
    _state = currentSignInState;
    notifyListeners();
  }

  Future<void> init() async {
    await appService.initializeApp();

    _initSyncServices();
    _syncData();
    
    _changeState(currentSignInState: AppLoaded());
  }

  // Services precisam ser iniciados após a inicialização do firebase,
  // isso pois utilizam o Cloud Firestore
  void _initSyncServices() {
    _syncServiceCategoryService = SyncServiceCategoryService.create();
  }

  Future<void> _syncData() async {
    await _syncServiceCategoryService.sync();
  }
}
