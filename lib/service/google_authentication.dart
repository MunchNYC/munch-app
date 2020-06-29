import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'base_authentication.dart';

class GoogleAuthentication implements BaseAuthentication {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthentication(this._auth, this._googleSignIn);

  @override
  Future<void> signIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }
}
