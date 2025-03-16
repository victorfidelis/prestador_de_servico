// ignore_for_file: public_member_api_docs, sort_constructors_first
class Address {
  final String city;
  final String complement;
  final String neighborhood;
  final String number;
  final String state;
  final String street;
  final String zipCode;

  Address({
    required this.city,
    required this.complement,
    required this.neighborhood,
    required this.number,
    required this.state,
    required this.street,
    required this.zipCode,
  });

  Address copyWith({
    String? city,
    String? complement,
    String? neighborhood,
    String? number,
    String? state,
    String? street,
    String? zipCode,
  }) {
    return Address(
      city: city ?? this.city,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      number: number ?? this.number,
      state: state ?? this.state,
      street: street ?? this.street,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  @override
  bool operator ==(covariant Address other) {
    return city == other.city &&
        complement == other.city &&
        neighborhood == other.city &&
        number == other.city &&
        state == other.city &&
        street == other.city &&
        zipCode == other.city;
  }

  @override
  int get hashCode =>
      city.hashCode ^
      complement.hashCode ^
      neighborhood.hashCode ^
      number.hashCode ^
      state.hashCode ^
      street.hashCode ^
      zipCode.hashCode;
}
