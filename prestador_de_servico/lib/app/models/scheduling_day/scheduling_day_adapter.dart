import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';

class SchedulingDayAdapter {
  static SchedulingDay fromDocumentSnapshot({required DocumentSnapshot doc}) {
    DateTime? day = DateTime.parse(doc.id);
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    return SchedulingDay(
      date: day,
      isSelected: false,
      hasService: map['hasService'],
      numberOfServices: map['numberOfServices'],
    );
  }
}
