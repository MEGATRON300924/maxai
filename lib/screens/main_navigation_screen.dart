import 'dart:ui';

import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'chat_screen.dart';
import 'discover_screen.dart';
import 'settings_screen.dart';

import '../core/app_colors.dart';


class MainNavigationScreen extends StatefulWidget {

  const MainNavigationScreen({
    super.key,
  });


  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();

}



class _MainNavigationScreenState
    extends State<MainNavigationScreen> {


  int currentIndex = 0;


  final pages = const [

    HomeScreen(),

    ChatScreen(),

    DiscoverScreen(),

    SettingsScreen(),

  ];



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      extendBody:
          true,


      body:
          IndexedStack(

        index:
            currentIndex,

        children:
            pages,

      ),



      bottomNavigationBar:

          Padding(

            padding:
                const EdgeInsets.only(

              left:
                  20,

              right:
                  20,

              bottom:
                  20,

            ),


            child:
                ClipRRect(

              borderRadius:
                  BorderRadius.circular(32),


              child:
                  BackdropFilter(

                filter:
                    ImageFilter.blur(

                  sigmaX:
                      20,

                  sigmaY:
                      20,

                ),


                child:
                    Container(

                  height:
                      72,


                  decoration:
                      BoxDecoration(

                    color:
                        Colors.white.withValues(
                          alpha:
                              .08,
                        ),


                    borderRadius:
                        BorderRadius.circular(32),


                    border:
                        Border.all(

                      color:
                          Colors.white.withValues(
                            alpha:
                                .15,
                          ),

                    ),

                  ),


                  child:
                      Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,


                    children: [

                      _NavigationItem(

                        icon:
                            Icons.home_rounded,

                        label:
                            "Home",

                        active:
                            currentIndex == 0,

                        onTap:
                            () => changePage(0),

                      ),



                      _NavigationItem(

                        icon:
                            Icons.chat_bubble_rounded,

                        label:
                            "Chat",

                        active:
                            currentIndex == 1,

                        onTap:
                            () => changePage(1),

                      ),



                      _NavigationItem(

                        icon:
                            Icons.explore_rounded,

                        label:
                            "Discover",

                        active:
                            currentIndex == 2,

                        onTap:
                            () => changePage(2),

                      ),



                      _NavigationItem(

                        icon:
                            Icons.settings_rounded,

                        label:
                            "Settings",

                        active:
                            currentIndex == 3,

                        onTap:
                            () => changePage(3),

                      ),

                    ],

                  ),

                ),

              ),

            ),

          ),

    );

  }



  void changePage(int index) {

    setState(() {

      currentIndex =
          index;

    });

  }

}



class _NavigationItem extends StatelessWidget {


  final IconData icon;

  final String label;

  final bool active;

  final VoidCallback onTap;



  const _NavigationItem({

    required this.icon,

    required this.label,

    required this.active,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap:
          onTap,


      child:
          AnimatedContainer(

        duration:
            const Duration(
              milliseconds: 250,
            ),


        padding:
            const EdgeInsets.symmetric(

          horizontal:
              14,

          vertical:
              8,

        ),


        decoration:
            BoxDecoration(

          borderRadius:
              BorderRadius.circular(22),


          color:
              active
                  ? AppColors.primary.withValues(
                      alpha:
                          .18,
                    )
                  : Colors.transparent,

        ),


        child:
            Column(

          mainAxisSize:
              MainAxisSize.min,


          children: [

            Icon(

              icon,

              size:
                  24,

              color:
                  active
                      ? AppColors.primary
                      : AppColors.darkTextHint,

            ),


            const SizedBox(
              height:
                  4,
            ),


            Text(

              label,

              style:
                  TextStyle(

                fontSize:
                    11,

                color:
                    active
                        ? AppColors.primary
                        : AppColors.darkTextHint,

              ),

            ),

          ],

        ),

      ),

    );

  }

}