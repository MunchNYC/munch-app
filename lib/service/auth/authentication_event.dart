abstract class AuthenticationEvent {}

class LoginWithGoogleEvent extends AuthenticationEvent {}

class LoginWithFacebookEvent extends AuthenticationEvent {}

class LoginWithAppleEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}
