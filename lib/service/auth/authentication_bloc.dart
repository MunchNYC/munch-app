import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:munch/repository/auth_repository.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/app.dart';
import 'authentication_state.dart';
import 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationState();

  final AuthRepo _authRepo = AuthRepo.getInstance();
  final UserRepo _userRepo = UserRepo.getInstance();

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
      // VERY IMPORTANT TO SET hostedDomain TO EMPTY STRING OTHERWISE GOOGLE SIGN IN WIDGET WILL CRASH ON iOS 9 and 10
      final googleSignInRepo = GoogleSignIn(
          signInOption: SignInOption.standard, scopes: ["profile", "email"], hostedDomain: "");

      final account = await googleSignInRepo.signIn();

      if (account != null) {

          FirebaseUser firebaseUser = await _authRepo.signInWithGoogle(account);

          await _authRepo.registerSocial(firebaseUser);

          await _authRepo.onSuccessfulFirebaseLogin(firebaseUser);

          yield LoginWithGoogleState.ready();
      } else {
        print("Google login cancelled.");
        yield LoginWithGoogleState.failed(
            message: App.translate("firebase_auth.google_login.cancelled.error"));
      }
    } catch (error) {
      print("Google login failed: " + error.toString());
      yield LoginWithGoogleState.failed(
          message: error.toString()); // "Google authentication failed."
    }
  }

  Stream<AuthenticationState> logout() async* {
    yield LogoutState.loading();
    // clearCurrentUser must be called before signOut, because user has to be authenticated to delete some data
    await _userRepo.clearCurrentUser();
    bool result = await _authRepo.signOut();
    if (result) {
      yield LogoutState.ready();
    } else {
      yield LogoutState.failed(message: App.translate("firebase_auth.logout.error"));
    }
  }
}
