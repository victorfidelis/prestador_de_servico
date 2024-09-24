// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
  });

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        id == other.id &&
        email == other.email &&
        name == other.name;
  }    

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
    );
  }
}
