abstract class BaseAuthentication {
  Future<String> signIn();

  Future<void> signOut();
}
