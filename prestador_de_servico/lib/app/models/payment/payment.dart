import 'package:replace_diacritic/replace_diacritic.dart';

enum PaymentType {
  money,
  pix,
  debitCard,
  creditCard,
  ticket,
  other,
}

class Payment {
  final String id;
  final PaymentType paymentType;
  final String name;
  final String urlIcon;
  final bool isActive;
  final DateTime? syncDate;
  final bool isDeleted;

  String get nameWithoutDiacritics => replaceDiacritic(name);

  Payment({
    required this.id,
    required this.paymentType,
    required this.name,
    required this.urlIcon,
    required this.isActive,
    this.syncDate,
    this.isDeleted = false,
  });

  Payment copyWith({
    String? id,
    PaymentType? paymentType,
    String? name,
    String? urlIcon,
    bool? isActive,
    DateTime? syncDate,
    bool? isDeleted,
  }) {
    return Payment(
      id: id ?? this.id,
      paymentType: paymentType ?? this.paymentType,
      name: name ?? this.name,
      urlIcon: urlIcon ?? this.urlIcon,
      isActive: isActive ?? this.isActive,
      syncDate: syncDate ?? this.syncDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(covariant Payment other) {
    return other.id == id &&
        other.paymentType == paymentType &&
        other.name == name &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^ paymentType.hashCode ^ name.hashCode ^ isActive.hashCode;
  }
}
