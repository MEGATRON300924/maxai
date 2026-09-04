import '../core/contracts/max_auth_contract.dart';

/// Temporary development adapter for MAX Auth.
///
/// Replace this class's internals with the official MAX Auth SDK/backend when
/// that service is complete. Consumers should depend on MaxAuthContract.
class MaxAuthService implements MaxAuthContract {
  MaxAuthService({MaxAuthContract? adapter}) : _adapter = adapter;

  final MaxAuthContract? _adapter;
  MaxAuthUser? _developmentUser;

  @override
  bool get isAuthenticated => _adapter?.isAuthenticated ?? _developmentUser != null;

  @override
  Future<MaxAuthUser?> currentUser() async {
    if (_adapter != null) return _adapter!.currentUser();
    return _developmentUser;
  }

  @override
  Future<MaxAuthResult> signIn({required String email, required String password}) async {
    if (_adapter != null) {
      return _adapter!.signIn(email: email, password: password);
    }
    if (email.trim().isEmpty || password.isEmpty) {
      return const MaxAuthResult.failure('Email and password are required.');
    }
    _developmentUser = MaxAuthUser(id: 'dev-user', email: email.trim());
    return MaxAuthResult.success(
      user: _developmentUser,
      message: 'Development authentication placeholder active.',
    );
  }

  @override
  Future<MaxAuthResult> signUp({required String email, required String password}) async {
    if (_adapter != null) {
      return _adapter!.signUp(email: email, password: password);
    }
    if (email.trim().isEmpty || password.length < 6) {
      return const MaxAuthResult.failure('Use a valid email and a password of at least 6 characters.');
    }
    _developmentUser = MaxAuthUser(id: 'dev-user', email: email.trim());
    return MaxAuthResult.success(
      user: _developmentUser,
      message: 'Development account created. MAX Auth backend is not connected yet.',
    );
  }

  @override
  Future<void> signOut() async {
    if (_adapter != null) return _adapter!.signOut();
    _developmentUser = null;
  }

  @override
  Future<MaxAuthResult> refreshSession() async {
    if (_adapter != null) return _adapter!.refreshSession();
    return MaxAuthResult.success(user: _developmentUser);
  }
}
