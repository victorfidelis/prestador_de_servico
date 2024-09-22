// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String phone;

  UserModel({
    required this.id,
    required this.uid,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
  });

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        id == other.id &&
        uid == other.uid &&
        email == other.email &&
        name == other.name;
  }    

  UserModel copyWith({
    String? id,
    String? uid,
    String? email,
    String? name,
    String? surname,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
    );
  }
}
