import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';

class UserAdapter {
  static fromUserCredendial({required UserCredential userCredential}) {
    return UserModel(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? 'Sem nome',
        surname: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        phone: userCredential.user!.phoneNumber ?? '',
      );
  }
}

