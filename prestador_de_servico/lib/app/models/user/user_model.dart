class UserModel {
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String phone;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
  });

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        uid == other.uid &&
        email == other.email &&
        name == other.name;
  }    
}
