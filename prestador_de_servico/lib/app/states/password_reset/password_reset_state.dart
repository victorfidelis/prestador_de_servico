abstract class PasswordResetState {} 


class WaitingUserSentEmail extends PasswordResetState {}
class LoadingSentEmail extends PasswordResetState {}
class ErrorSentEmail extends PasswordResetState {
  final String? emailMessage;

  ErrorSentEmail({this.emailMessage});
}
class ResetEmailSent extends PasswordResetState {}