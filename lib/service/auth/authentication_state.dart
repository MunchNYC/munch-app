import 'package:munch/service/util/super_state.dart';

class AuthenticationState extends SuperState {
  AuthenticationState({initial = true, loading = false, hasError = false, message = ""})
      : super(initial: initial, loading: loading, hasError: hasError, message: message);

  AuthenticationState.ready({data}) : super.ready(data: data);

  AuthenticationState.loading({message = ""}) : super.loading(message: message);

  AuthenticationState.failed({message = ""}) : super.failed(message: message);
}

class LoginWithGoogleState extends AuthenticationState {
  LoginWithGoogleState.ready({data}) : super.ready(data: data);

  LoginWithGoogleState.loading({message = ""}) : super.loading(message: message);

  LoginWithGoogleState.failed({message = ""}) : super.failed(message: message);
}

class LoginWithFacebookState extends AuthenticationState {
  LoginWithFacebookState.ready({data}) : super.ready(data: data);

  LoginWithFacebookState.loading({message = ""}) : super.loading(message: message);

  LoginWithFacebookState.failed({message = ""}) : super.failed(message: message);
}

class LoginWithAppleState extends AuthenticationState {
  LoginWithAppleState.ready({data}) : super.ready(data: data);

  LoginWithAppleState.loading({message = ""}) : super.loading(message: message);

  LoginWithAppleState.failed({message = ""}) : super.failed(message: message);
}

class LogoutState extends AuthenticationState {
  LogoutState.ready({data}) : super.ready(data: data);

  LogoutState.loading({message = ""}) : super.loading(message: message);

  LogoutState.failed({message = ""}) : super.failed(message: message);
}
