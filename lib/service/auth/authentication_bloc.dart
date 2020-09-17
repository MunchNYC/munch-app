import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/auth_repository.dart';
import 'package:munch/util/app.dart';
import 'authentication_state.dart';
import 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState());

  final AuthRepo _authRepo = AuthRepo.getInstance();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is LoginWithGoogleEvent) {
      yield* loginWithGoogle();
    } else if (event is LogoutEvent) {
      yield* logout();
    }
  }

  Stream<AuthenticationState> loginWithGoogle() async* {
    // No need for the indicator while popup/browser is opened, that's why we don't set `loading` state before previous await
    yield LoginWithGoogleState.loading();

    try {
      User signedInUser = await _authRepo.signInWithGoogle();

      if (signedInUser != null) {
        yield LoginWithGoogleState.ready();
      } else {
        print("Google login cancelled.");
        yield LoginWithGoogleState.failed(message: App.translate("firebase_auth.google_login.cancelled.error"));
      }
    } catch (error) {
      print("Google login failed: " + error.toString());
      yield LoginWithGoogleState.failed(message: error.toString()); // "Google authentication failed."
    }
  }

  Stream<AuthenticationState> logout() async* {
    yield LogoutState.loading();

    bool result = await _authRepo.signOut();
    if (result) {
      yield LogoutState.ready();
    } else {
      yield LogoutState.failed(message: App.translate("firebase_auth.logout.error"));
    }
  }
}
