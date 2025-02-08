import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';

class UserAdapter {
  static Map<String, dynamic> toMap({required User user}) {
    return {
      'id': user.id,
      'isAdmin': user.isAdmin,
      'name': user.name,
      'surname': user.surname,
      'phone': user.phone,
      'email': user.email,
      'password': user.password,
      'confirmPassword': user.confirmPassword,
    };
  }

  static User fromMap({required Map<String, dynamic> map}) {
    return User(
      id: map['id'],
      isAdmin: map['isAdmin'],
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
      phone: map['phone'],
      password: map.containsKey('password') ? map['password'] : '',
      confirmPassword: map.containsKey('confirmPassword') ? map['confirmPassword'] : '',
    );
  }

  static Map<String, dynamic> toFirebaseMap({required User user}) {
    return {
      'name': user.name,
      'isAdmin': user.isAdmin,
      'surname': user.surname,
      'phone': user.phone,
      'email': user.email
    };
  }

  static User fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;

    return User(
      id: map['id'],
      isAdmin: map['isAdmin'],
      name: map['name'],
      surname: map['surname'],
      phone: map['phone'],
      email: map['email'],
    );
  }

  static User fromServiceSchedulingMap({required Map<String, dynamic> map}) {
    return User(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
    );
  }
}
