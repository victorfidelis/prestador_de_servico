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
  final double averageRating;
  final int pendingProviderSchedules;
  final int pendingClientSchedules;
  final int confirmedSchedules;
  final int inServiceSchedules;
  final int performedSchedules;
  final int deniedSchedules;
  final int canceledByProviderSchedules;
  final int canceledByClientSchedules;
  final int expiredSchedules;

  User({
    this.id = '',
    this.isAdmin = false,
    this.email = '',
    required this.name,
    required this.surname,
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.averageRating = 0,
    this.pendingProviderSchedules = 0,
    this.pendingClientSchedules = 0,
    this.confirmedSchedules = 0,
    this.inServiceSchedules = 0,
    this.performedSchedules = 0,
    this.deniedSchedules = 0,
    this.canceledByProviderSchedules = 0,
    this.canceledByClientSchedules = 0,
    this.expiredSchedules = 0,
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
    double? averageRating,
    int? pendingProviderSchedules,
    int? pendingClientSchedules,
    int? confirmedSchedules,
    int? inServiceSchedules,
    int? performedSchedules,
    int? deniedSchedules,
    int? canceledByProviderSchedules,
    int? canceledByClientSchedules,
    int? expiredSchedules,
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
      averageRating: averageRating ?? this.averageRating,
      pendingProviderSchedules: pendingProviderSchedules ?? this.pendingProviderSchedules,
      pendingClientSchedules: pendingClientSchedules ?? this.pendingClientSchedules,
      confirmedSchedules: confirmedSchedules ?? this.confirmedSchedules,
      inServiceSchedules: inServiceSchedules ?? this.inServiceSchedules,
      performedSchedules: performedSchedules ?? this.performedSchedules,
      deniedSchedules: deniedSchedules ?? this.deniedSchedules,
      canceledByProviderSchedules: canceledByProviderSchedules ?? this.canceledByProviderSchedules,
      canceledByClientSchedules: canceledByClientSchedules ?? this.canceledByClientSchedules,
      expiredSchedules: expiredSchedules ?? this.expiredSchedules,
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
