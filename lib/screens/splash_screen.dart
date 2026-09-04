import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'onboarding_screen.dart';
import 'main_navigation.dart';



class SplashScreen extends StatefulWidget {


  const SplashScreen({

    super.key,

  });



  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();


}



class _SplashScreenState
    extends State<SplashScreen> {



  @override
  void initState() {


    super.initState();


    _checkUser();


  }





  Future<void> _checkUser() async {


    await Future.delayed(

      const Duration(

        seconds:
            2,

      ),

    );



    final prefs =
        await SharedPreferences.getInstance();



    final completed =

        prefs.getBool(

          "onboarding_completed",

        )

        ??

        false;





    if(!mounted){

      return;

    }





    if(completed){



      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>

              const MainNavigation(),

        ),

      );



    }

    else{



      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>

              const OnboardingScreen(),

        ),

      );


    }


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:

          Colors.black,



      body:

          Center(

        child:

            Image.asset(

          "assets/images/app_icon.png",



          width:

              130,



          height:

              130,

        ),

      ),

    );


  }

}