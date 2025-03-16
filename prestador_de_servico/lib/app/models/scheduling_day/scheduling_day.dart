// ignore_for_file: public_member_api_docs, sort_constructors_first
class SchedulingDay {
  final DateTime date;
  final bool isSelected;
  final bool hasService;
  final bool isToday;
  final int numberOfServices;

  SchedulingDay({
    required this.date,
    required this.isSelected,
    required this.hasService,
    required this.isToday,
    required this.numberOfServices,
  });

  SchedulingDay copyWith({
    DateTime? date,
    bool? isSelected,
    bool? hasService,
    bool? isToday,
    int? numberOfServices,
  }) {
    return SchedulingDay(
      date: date ?? this.date,
      isSelected: isSelected ?? this.isSelected,
      hasService: hasService ?? this.hasService,
      isToday: isToday ?? this.isToday,
      numberOfServices: numberOfServices ?? this.numberOfServices,
    );
  }

  @override
  bool operator ==(covariant SchedulingDay other) {
    if (identical(this, other)) return true;

    return date == other.date &&
        isSelected == other.isSelected &&
        isToday == other.isToday &&
        hasService == other.hasService &&
        numberOfServices == other.numberOfServices;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        isSelected.hashCode ^
        isToday.hashCode ^
        hasService.hashCode ^
        numberOfServices.hashCode;
  }
}
