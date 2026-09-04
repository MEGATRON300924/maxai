import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'screens/splash_screen.dart';


import 'providers/home_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/plan_provider.dart';
import 'providers/onboarding_provider.dart';


import 'services/auth_service.dart';


import 'ai/context_provider.dart';
import 'ai/memory_manager.dart';


import 'core/app_colors.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Supabase.initialize(

    url: "",

    anonKey: "",

  );


  runApp(

    const MaxAIApp(),

  );

}





class MaxAIApp extends StatelessWidget {


  const MaxAIApp({

    super.key,

  });



  @override
  Widget build(BuildContext context) {


    return MultiProvider(

      providers: [


        ChangeNotifierProvider(

          create: (_) =>

              HomeProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>

              ChatProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>

              ProfileProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>

              PlanProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>

              OnboardingProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>

              MaxContextProvider(),

        ),



        ChangeNotifierProvider.value(

          value:

              MemoryManager.instance,

        ),



        ChangeNotifierProvider.value(

          value:

              AuthService.instance,

        ),


      ],



      child:

          MaterialApp(

        debugShowCheckedModeBanner:

            false,



        title:

            "MAX AI",



        theme:

            ThemeData(

          brightness:

              Brightness.dark,



          scaffoldBackgroundColor:

              AppColors.darkBackground,



          useMaterial3:

              true,

        ),



        home:

            const SplashScreen(),

      ),

    );

  }

}