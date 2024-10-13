import 'package:prestador_de_servico/app/models/user/user.dart';

final userNoNetworkConection = User(
  id: '1',
  isAdmin: true,
  email: 'userNoNetworkConection@test.com',
  name: 'userNoNetworkConection',
  surname: 'test',
  phone: '11912345678',
  password: '123456',
  confirmPassword: '123456',
);

final userEmailAlreadyUse = User(
  id: '2',
  isAdmin: true,
  email: 'userEmailAlreadyUse@test.com',
  name: 'userEmailAlreadyUse',
  surname: 'test',
  phone: '11912345678',
  password: '123456',
  confirmPassword: '123456',
);

final validUserToCreate = User(
  id: '3',
  isAdmin: true,
  email: 'validUserToCreate@test.com',
  name: 'validUserToCreate',
  surname: 'test',
  phone: '11912345678',
  password: '123456',
  confirmPassword: '123456',
);

final userNotFoud = User(
  id: '4',
  isAdmin: true,
  email: 'userNotFoud@test.com',
  name: 'userNotFoud',
  surname: 'test',
  phone: '11912345678',
  password: '123456',
  confirmPassword: '123456',
);

final userInvalidCredentials = User(
  id: '5',
  isAdmin: true,
  email: 'userInvalidCredentials@test.com',
  name: 'userInvalidCredentials',
  surname: 'test',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final userTooManyRequests = User(
  id: '6',
  isAdmin: true,
  email: 'userTooManyRequests@test.com',
  name: 'userTooManyRequests',
  surname: 'test',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final validUserToSignIn = User(
  id: '7',
  isAdmin: true,
  email: 'validUserToSignIn@test.com',
  name: 'validUserToSignIn',
  surname: 'test',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final validUserSendResetPasswordEmail = User(
  id: '7',
  isAdmin: true,
  email: 'validUserSendResetPasswordEmail@test.com',
  name: 'validUserSendResetPasswordEmail',
  surname: 'test',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final userWithoutEmail = User(
  id: '8',
  isAdmin: true,
  email: '',
  name: 'userWithoutEmail',
  surname: 'test',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final userWithoutName = User(
  id: '9',
  isAdmin: true,
  email: 'userWithoutName@test.com',
  name: '',
  surname: 'test',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final userWithoutSurname = User(
  id: '10',
  isAdmin: true,
  email: 'userWithoutSurname@test.com',
  name: 'userWithoutSurname',
  surname: '',
  phone: '11912345678',
  password: '1234567',
  confirmPassword: '1234567',
);

final userWithoutPhone = User(
  id: '11',
  isAdmin: true,
  email: 'userWithoutSurname@test.com',
  name: 'userWithoutSurname',
  surname: 'test',
  phone: '',
  password: '1234567',
  confirmPassword: '1234567',
);

final userWithoutPassword = User(
  id: '12',
  isAdmin: true,
  email: 'userWithoutSurname@test.com',
  name: 'userWithoutSurname',
  surname: 'test',
  phone: '11912345678',
  password: '',
  confirmPassword: '123456',
);

final userWithoutConfirmPassword = User(
  id: '12',
  isAdmin: true,
  email: 'userWithoutSurname@test.com',
  name: 'userWithoutSurname',
  surname: 'test',
  phone: '11912345678',
  password: '123456',
  confirmPassword: '',
);

final userInvalidConfirmPassword = User(
  id: '13',
  isAdmin: true,
  email: 'userWithoutSurname@test.com',
  name: 'userWithoutSurname',
  surname: 'test',
  phone: '11912345678',
  password: '123456',
  confirmPassword: '123789',
);