import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../services/auth_service.dart';


import 'main_navigation.dart';



class TestAuthScreen extends StatefulWidget {


  const TestAuthScreen({
    super.key,
  });



  @override
  State<TestAuthScreen> createState() =>
      _TestAuthScreenState();

}



class _TestAuthScreenState
    extends State<TestAuthScreen> {


  final email =
      TextEditingController();



  final password =
      TextEditingController();





  Future<void> login() async {



    await context

        .read<AuthService>()

        .signIn(

          email:
              email.text,

          password:
              password.text,

        );



    if(!mounted){

      return;

    }



    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const MainNavigation(),

      ),

    );


  }





  @override
  Widget build(BuildContext context) {



    return Scaffold(

      body:

          Padding(

        padding:
            const EdgeInsets.all(24),



        child:

            Column(

          mainAxisAlignment:

              MainAxisAlignment.center,



          children: [



            TextField(

              controller:
                  email,

              decoration:

                  const InputDecoration(

                hintText:
                    "Email",

              ),

            ),



            TextField(

              controller:
                  password,

              obscureText:
                  true,

              decoration:

                  const InputDecoration(

                hintText:
                    "Password",

              ),

            ),



            ElevatedButton(

              onPressed:
                  login,

              child:

                  const Text(
                    "Continue",
                  ),

            ),



          ],

        ),

      ),

    );

  }

}