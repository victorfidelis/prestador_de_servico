import 'package:firebase_core/firebase_core.dart';
import 'package:prestador_de_servico/app/services/app/app_service.dart';
import 'package:prestador_de_servico/firebase_options.dart';

class FirebaseAppService implements AppService {
  
  @override
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}