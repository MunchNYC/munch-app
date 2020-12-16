import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/auth_repository.dart';
import 'package:munch/util/app.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState());

  final AuthRepo _authRepo = AuthRepo.getInstance();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is LoginWithGoogleEvent) {
      yield* loginWithGoogle();
    } else if (event is LoginWithFacebookEvent) {
      yield* loginWithFacebook();
    } else if (event is LoginWithAppleEvent) {
      yield* loginWithApple();
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

  Stream<AuthenticationState> loginWithFacebook() async* {
    // No need for the indicator while popup/browser is opened, that's why we don't set `loading` state before previous await
    yield LoginWithFacebookState.loading();

    try {
      User signedInUser = await _authRepo.signInWithFacebook();

      if (signedInUser != null) {
        yield LoginWithFacebookState.ready();
      } else {
        print("Facebook login cancelled.");
        yield LoginWithFacebookState.failed(message: App.translate("firebase_auth.facebook_login.cancelled.error"));
      }
    } catch (error) {
      print("Facebook login failed: " + error.toString());
      yield LoginWithFacebookState.failed(message: error.toString()); // "Facebook authentication failed."
    }
  }

  Stream<AuthenticationState> loginWithApple() async* {
    // No need for the indicator while popup/browser is opened, that's why we don't set `loading` state before previous await
    yield LoginWithAppleState.loading();

    try {
      User signedInUser = await _authRepo.signInWithApple();

      if (signedInUser != null) {
        yield LoginWithAppleState.ready();
      } else {
        print("Apple login cancelled.");
        yield LoginWithAppleState.failed(message: App.translate("firebase_auth.apple_login.cancelled.error"));
      }
    } catch (error) {
      print("Apple login failed: " + error.toString());
      yield LoginWithAppleState.failed(message: error.toString()); // "Apple authentication failed."
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
