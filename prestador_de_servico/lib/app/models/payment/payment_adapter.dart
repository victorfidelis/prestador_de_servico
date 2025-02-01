

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';

class PaymentAdapter {

  static Map<String, dynamic> toFirebaseMap({required Payment payment}) {
    return {
      'paymentType': payment.paymentType.index,
      'name': payment.name,
      'urlIcon': payment.urlIcon,
      'isActive': payment.isActive,
      'dateSync': FieldValue.serverTimestamp(), // Todo envio para o firebase deve conter a data atual do servidor
      'isDeleted': false,
    };
  }

  static Payment fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    Payment payment = Payment(
      id: doc.id,
      paymentType: PaymentType.values[map
      ['paymentType']],
      name: map['name'],
      urlIcon: map['urlIcon'],
      isActive: map['isActive'],
      syncDate: (map['dateSync'] as Timestamp).toDate(),
    );

    return payment;
  }

  static Payment fromSqflite({required Map map}) {
    return Payment(
      id: map['id'],
      paymentType: PaymentType.values[map['paymentType']],
      name: map['name'],
      urlIcon: map['urlIcon'],
      isActive: map['isActive'] == 1,
    );
  }
}