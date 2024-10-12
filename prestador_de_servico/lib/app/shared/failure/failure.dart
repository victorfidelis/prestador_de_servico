import 'package:cloud_firestore/cloud_firestore.dart';

class Failure {
  final String message;

  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class UserNotFoundFailure extends Failure {
  UserNotFoundFailure(super.message);
}

class InvalidCredentialFailure extends Failure {
  InvalidCredentialFailure(super.message);
}

class TooManyRequestsFailure extends Failure {
  TooManyRequestsFailure(super.message);
}

class EmailNotVerifiedFailure extends Failure {
  EmailNotVerifiedFailure(super.message);
}

class SendEmailVerificationFailure extends Failure {
  SendEmailVerificationFailure(super.message);
}

class EmailAlreadyInUseFailure extends Failure {
  EmailAlreadyInUseFailure(super.message);
}