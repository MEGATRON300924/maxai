import 'package:flutter/material.dart';


import '../models/user_profile.dart';



class ProfileProvider extends ChangeNotifier {


  UserProfile? _profile;



  UserProfile? get profile =>
      _profile;



  String get displayName =>


      _profile?.name ??

      "User";



  String get subscriptionPlan =>


      "MAX BASIC";



  String get memory {


    if(_profile == null){

      return "";

    }



    return """

Name:
${_profile!.name}


Age:
${_profile!.age ?? "Unknown"}


Country:
${_profile!.country ?? "Unknown"}


Interests:
${_profile!.interests ?? "Unknown"}


Religion:
${_profile!.religion ?? "Unknown"}


Preferences:
${_profile!.preferences ?? "None"}

""";

  }





  void loadProfile(
    UserProfile profile,
  ){


    _profile =
        profile;


    notifyListeners();

  }





  void clearProfile(){


    _profile =
        null;


    notifyListeners();

  }

}