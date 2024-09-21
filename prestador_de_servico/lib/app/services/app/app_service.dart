import 'package:prestador_de_servico/app/services/app/firebase_app_service.dart';

abstract class AppService {

  factory AppService.create() {
    return FirebaseAppService();
  }

  Future<void> initializeApp();
}