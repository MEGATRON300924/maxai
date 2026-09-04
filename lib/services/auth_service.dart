import 'package:flutter/material.dart';



class AuthService extends ChangeNotifier {


  AuthService._();



  static final AuthService instance =
      AuthService._();



  bool _loggedIn = false;



  bool get loggedIn =>
      _loggedIn;



  String? _userId;



  String? get userId =>
      _userId;



  String? _email;



  String? get email =>
      _email;



  Future<bool> signUp({

    required String email,

    required String password,

  }) async {



    // Temporary testing auth

    // Will be replaced by MAX Auth backend



    _loggedIn =
        true;


    _email =
        email;


    _userId =
        DateTime.now()
            .millisecondsSinceEpoch
            .toString();



    notifyListeners();



    return true;

  }





  Future<bool> signIn({

    required String email,

    required String password,

  }) async {



    _loggedIn =
        true;


    _email =
        email;


    _userId =
        DateTime.now()
            .millisecondsSinceEpoch
            .toString();



    notifyListeners();



    return true;

  }





  Future<void> signOut() async {



    _loggedIn =
        false;



    _email =
        null;



    _userId =
        null;



    notifyListeners();


  }


}