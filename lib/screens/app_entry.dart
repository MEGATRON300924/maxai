import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'main_navigation_screen.dart';
import 'onboarding_screen.dart';



class AppEntry extends StatefulWidget {

  const AppEntry({
    super.key,
  });


  @override
  State<AppEntry> createState() =>
      _AppEntryState();

}



class _AppEntryState
    extends State<AppEntry> {


  bool loading = true;

  bool loggedIn = false;



  @override
  void initState() {

    super.initState();

    checkAuth();

  }



  Future<void> checkAuth() async {


    loggedIn =
        await AuthService.instance.isLoggedIn;


    setState(() {

      loading =
          false;

    });

  }



  @override
  Widget build(BuildContext context) {


    if (loading) {

      return const Scaffold(

        body:
            Center(

          child:
              CircularProgressIndicator(),

        ),

      );

    }



    if (loggedIn) {

      return const MainNavigationScreen();

    }



    return const OnboardingScreen();

  }

}