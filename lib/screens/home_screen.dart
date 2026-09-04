import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../providers/chat_provider.dart';

import '../ai/context_provider.dart';

import '../core/app_colors.dart';
import '../core/app_spacing.dart';

import '../widgets/max_svg_icon.dart';
import '../widgets/max_orb.dart';



class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });



  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {



  @override
  void initState() {

    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) {


      context
          .read<MaxContextProvider>()
          .updateScreen(
            "home",
          );


    });

  }





  @override
  Widget build(BuildContext context) {


    final profile =
        context.watch<ProfileProvider>();


    final chat =
        context.watch<ChatProvider>();



    return Scaffold(

      backgroundColor:
          AppColors.darkBackground,



      body:

          SafeArea(

        child:

            SingleChildScrollView(

          padding:

              const EdgeInsets.all(
                AppSpacing.screenHorizontal,
              ),



          child:

              Column(

            crossAxisAlignment:

                CrossAxisAlignment.start,



            children: [



              _header(
                profile.displayName,
              ),



              const SizedBox(
                height: 35,
              ),



              const Center(

                child:

                    MaxOrb(

                  size:
                      190,

                ),

              ),



              const SizedBox(
                height: 40,
              ),



              _quickActions(
                chat,
              ),



              const SizedBox(
                height: 30,
              ),



              _maxPlanCard(
                profile.subscriptionPlan,
              ),



            ],

          ),

        ),

      ),

    );

  }





  Widget _header(
    String name,
  ) {


    return Row(

      children: [


        Expanded(

          child:

              Column(

            crossAxisAlignment:

                CrossAxisAlignment.start,



            children: [



              Text(

                "Welcome back",

                style:

                    TextStyle(

                  color:

                      Colors.white
                          .withValues(
                            alpha: 0.6,
                          ),

                  fontSize:
                      14,

                ),

              ),



              Text(

                name,

                style:

                    const TextStyle(

                  color:
                      Colors.white,

                  fontSize:
                      28,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

            ],

          ),

        ),



        const MaxSvgIcon(

          asset:
              "profile",

          size:
              48,

        ),

      ],

    );

  }





  Widget _quickActions(
    ChatProvider chat,
  ) {


    return Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceAround,



      children: [



        _action(

          "new",

          "Chat",

          () {

            chat.clearChat();

          },

        ),



        _action(

          "search",

          "Search",

          () {},

        ),



        _action(

          "saved",

          "Saved",

          () {},

        ),



      ],

    );

  }





  Widget _action(

    String icon,

    String text,

    VoidCallback onTap,

  ) {


    return GestureDetector(

      onTap:
          onTap,



      child:

          Column(

        children: [



          MaxSvgIcon(

            asset:
                icon,

            size:
                55,

          ),



          const SizedBox(
            height: 8,
          ),



          Text(

            text,

            style:

                const TextStyle(

              color:
                  Colors.white,

              fontSize:
                  12,

            ),

          ),

        ],

      ),

    );

  }





  Widget _maxPlanCard(
    String plan,
  ) {


    return Container(

      width:
          double.infinity,



      padding:
          const EdgeInsets.all(
            20,
          ),



      decoration:

          BoxDecoration(

        color:

            Colors.white
                .withValues(
                  alpha: 0.08,
                ),



        borderRadius:

            BorderRadius.circular(
              24,
            ),



        border:

            Border.all(

          color:

              Colors.white
                  .withValues(
                    alpha: 0.15,
                  ),

        ),

      ),



      child:

          Row(

        children: [



          const MaxSvgIcon(

            asset:
                "config",

            size:
                45,

          ),



          const SizedBox(
            width: 15,
          ),



          Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,



            children: [



              const Text(

                "MAX Plan",

                style:

                    TextStyle(

                  color:
                      Colors.white,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),



              Text(

                plan,

                style:

                    TextStyle(

                  color:

                      Colors.white
                          .withValues(
                            alpha: 0.6,
                          ),

                ),

              ),



            ],

          ),



        ],

      ),

    );

  }

}