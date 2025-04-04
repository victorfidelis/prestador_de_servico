// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final bool isAdmin;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final String password;
  final String confirmPassword;

  User({
    this.id = '',
    this.isAdmin = false,
    this.email = '',
    required this.name,
    required this.surname,
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
  });

  String get fullname => '$name $surname'; 

  User copyWith({
    String? id,
    bool? isAdmin,
    String? email,
    String? name,
    String? surname,
    String? phone,
    String? password,
    String? confirmPassword,
  }) {
    return User(
      id: id ?? this.id,
      isAdmin: isAdmin ?? this.isAdmin,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  bool operator ==(covariant User other) {
    return id == other.id && email == other.email && name == other.name && surname == other.surname;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ surname.hashCode;
  }
}
