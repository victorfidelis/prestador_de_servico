import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';

class UserAdapter {

  static Map<String, dynamic> toMap({required UserModel user}) {
    return {
      'id': user.id,
      'uid': user.uid,
      'name': user.name,
      'surname': user.surname,
      'phone': user.phone,
      'email': user.email
    };
  }

  static UserModel fromMap({required Map<String, dynamic> map}) {
    return UserModel(
      id: map['id'],
      uid: map['uid'],
      name: map['name'],
      surname: map['surname'],
      phone: map['phone'],
      email: map['email'],
    );
  } 

  static Map<String, dynamic> toFirebaseMap({required UserModel user}) {
    return {
      'uid': user.uid,
      'name': user.name,
      'surname': user.surname,
      'phone': user.phone,
      'email': user.email
    };
  }

  static UserModel? fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;

    UserModel? user;
    if (map.containsKey('uid')) {
      user = UserAdapter.fromMap(map: map);
    }
    return user;
  }
}

