import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'chat_screen.dart';

import '../widgets/max_svg_icon.dart';

import '../core/app_colors.dart';



class MainNavigation extends StatefulWidget {

  const MainNavigation({
    super.key,
  });



  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();

}



class _MainNavigationState
    extends State<MainNavigation> {


  int currentIndex = 0;



  final pages = const [

    HomeScreen(),

    ChatScreen(),

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body:

          IndexedStack(

        index:
            currentIndex,

        children:
            pages,

      ),



      bottomNavigationBar:

          Container(

        decoration:

            BoxDecoration(

          color:

              AppColors.darkCard,

          border:

              Border(

            top:

                BorderSide(

              color:

                  AppColors.darkBorder,

            ),

          ),

        ),



        child:

            NavigationBar(

          backgroundColor:

              Colors.transparent,



          indicatorColor:

              AppColors.primary
                  .withValues(
                    alpha: 0.25,
                  ),



          selectedIndex:

              currentIndex,



          onDestinationSelected:

              (index) {


            setState(() {

              currentIndex =
                  index;

            });


          },



          destinations: [



            NavigationDestination(

              icon:

                  const MaxSvgIcon(

                asset:
                    "home",

                size:
                    30,

              ),



              label:
                  "Home",

            ),



            NavigationDestination(

              icon:

                  const MaxSvgIcon(

                asset:
                    "new",

                size:
                    30,

              ),



              label:
                  "MAX",

            ),



          ],

        ),

      ),

    );

  }

}