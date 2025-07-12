import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';

class UserConverter {
  static Map<String, dynamic> toMap({required User user}) {
    return {
      'id': user.id,
      'isAdmin': user.isAdmin,
      'name': user.name,
      'surname': user.surname,
      'phone': user.phone,
      'email': user.email,
      'averageRating': user.averageRating,
      'pendingProviderSchedules': user.pendingProviderSchedules,
      'pendingClientSchedules': user.pendingClientSchedules,
      'confirmedSchedules': user.confirmedSchedules,
      'inServiceSchedules': user.inServiceSchedules,
      'performedSchedules': user.performedSchedules,
      'deniedSchedules': user.deniedSchedules,
      'canceledByProviderSchedules': user.canceledByProviderSchedules,
      'canceledByClientSchedules': user.canceledByClientSchedules,
      'expiredSchedules': user.expiredSchedules,
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
      averageRating: map.containsKey('averageRating') ? map['averageRating'] : 0,
      pendingProviderSchedules: map.containsKey('pendingProviderSchedules') ? map['pendingProviderSchedules'] : 0,
      pendingClientSchedules: map.containsKey('pendingClientSchedules') ? map['pendingClientSchedules'] : 0,
      confirmedSchedules: map.containsKey('confirmedSchedules') ? map['confirmedSchedules'] : 0,
      inServiceSchedules: map.containsKey('inServiceSchedules') ? map['inServiceSchedules'] : 0,
      performedSchedules: map.containsKey('performedSchedules') ? map['performedSchedules'] : 0,
      deniedSchedules: map.containsKey('deniedSchedules') ? map['deniedSchedules'] : 0,
      canceledByProviderSchedules:
          map.containsKey('canceledByProviderSchedules') ? map['canceledByProviderSchedules'] : 0,
      canceledByClientSchedules: map.containsKey('canceledByClientSchedules') ? map['canceledByClientSchedules'] : 0,
      expiredSchedules: map.containsKey('expiredSchedules') ? map['expiredSchedules'] : 0,
    );
  }

  static Map<String, dynamic> toFirebaseMap({required User user}) {
    return {
      'name': user.name,
      'isAdmin': user.isAdmin,
      'surname': user.surname,
      'phone': user.phone,
      'email': user.email,
      'averageRating': user.averageRating,
      'pendingProviderSchedules': user.pendingProviderSchedules,
      'pendingClientSchedules': user.pendingClientSchedules,
      'confirmedSchedules': user.confirmedSchedules,
      'inServiceSchedules': user.inServiceSchedules,
      'performedSchedules': user.performedSchedules,
      'deniedSchedules': user.deniedSchedules,
      'canceledByProviderSchedules': user.canceledByProviderSchedules,
      'canceledByClientSchedules': user.canceledByClientSchedules,
      'expiredSchedules': user.expiredSchedules,
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
      averageRating: map.containsKey('averageRating') ? map['averageRating'] : 0,
      pendingProviderSchedules: map.containsKey('pendingProviderSchedules') ? map['pendingProviderSchedules'] : 0,
      pendingClientSchedules: map.containsKey('pendingClientSchedules') ? map['pendingClientSchedules'] : 0,
      confirmedSchedules: map.containsKey('confirmedSchedules') ? map['confirmedSchedules'] : 0,
      inServiceSchedules: map.containsKey('inServiceSchedules') ? map['inServiceSchedules'] : 0,
      performedSchedules: map.containsKey('performedSchedules') ? map['performedSchedules'] : 0,
      deniedSchedules: map.containsKey('deniedSchedules') ? map['deniedSchedules'] : 0,
      canceledByProviderSchedules:
          map.containsKey('canceledByProviderSchedules') ? map['canceledByProviderSchedules'] : 0,
      canceledByClientSchedules: map.containsKey('canceledByClientSchedules') ? map['canceledByClientSchedules'] : 0,
      expiredSchedules: map.containsKey('expiredSchedules') ? map['expiredSchedules'] : 0,
    );
  }
}
