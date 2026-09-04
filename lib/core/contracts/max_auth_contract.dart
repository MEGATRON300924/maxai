/// Contract for the MAX ecosystem identity provider.
///
/// MAX Auth is intentionally not implemented yet. The application talks to
/// this contract so the real MAX Auth SDK/backend can replace the development
/// implementation without changing screens or controllers.
abstract interface class MaxAuthContract {
  Future<MaxAuthUser?> currentUser();
  Future<MaxAuthResult> signIn({required String email, required String password});
  Future<MaxAuthResult> signUp({required String email, required String password});
  Future<void> signOut();
  Future<MaxAuthResult> refreshSession();
  bool get isAuthenticated;
}

class MaxAuthUser {
  const MaxAuthUser({required this.id, required this.email, this.displayName});

  final String id;
  final String email;
  final String? displayName;
}

class MaxAuthResult {
  const MaxAuthResult.success({this.user, this.message}) : isSuccess = true;
  const MaxAuthResult.failure(this.message) : isSuccess = false, user = null;

  final bool isSuccess;
  final String? message;
  final MaxAuthUser? user;
}
