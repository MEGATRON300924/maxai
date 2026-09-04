import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool get isLoggedIn => _loggedIn;

  String? _userId;
  String? get userId => _userId;

  String? _email;
  String? get email => _email;

  Future<bool> signUp({required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) return false;
    _loggedIn = true;
    _email = email.trim();
    _userId = DateTime.now().millisecondsSinceEpoch.toString();
    notifyListeners();
    return true;
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) return false;
    _loggedIn = true;
    _email = email.trim();
    _userId = DateTime.now().millisecondsSinceEpoch.toString();
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _loggedIn = false;
    _email = null;
    _userId = null;
    notifyListeners();
  }
}
