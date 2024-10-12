abstract class PasswordResetState {} 


class WaitingUserSentEmail extends PasswordResetState {}
class LoadingSentEmail extends PasswordResetState {}
class ErrorPasswordResetEmail extends PasswordResetState {
  final String? message;

  ErrorPasswordResetEmail({this.message});
}
class PasswordResetEmailSent extends PasswordResetState {}