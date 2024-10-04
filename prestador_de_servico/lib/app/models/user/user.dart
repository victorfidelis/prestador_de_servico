// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final bool isAdmin;
  final String email;
  final String name;
  final String surname;
  final String phone;

  User({
    required this.id,
    required this.isAdmin,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
  });

  @override
  bool operator ==(Object other) {
    return other is User &&
        id == other.id &&
        email == other.email &&
        name == other.name;
  }    

  User copyWith({
    String? id,
    bool? isAdmin,
    String? email,
    String? name,
    String? surname,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      isAdmin: isAdmin ?? this.isAdmin,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
    );
  }
}
