import 'package:flutter/material.dart';


import 'liquid_glass_container.dart';



class MaxTypingIndicator extends StatefulWidget {


  const MaxTypingIndicator({

    super.key,

  });



  @override
  State<MaxTypingIndicator> createState() =>

      _MaxTypingIndicatorState();


}





class _MaxTypingIndicatorState

    extends State<MaxTypingIndicator>

    with SingleTickerProviderStateMixin {


  late AnimationController controller;



  @override
  void initState(){

    super.initState();



    controller =

        AnimationController(

          vsync:

              this,

          duration:

              const Duration(

                seconds:

                    1,

              ),

        )

        ..repeat();


  }





  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context){


    return LiquidGlassContainer(

      radius:

          20,



      child:

          Padding(

        padding:

            const EdgeInsets.symmetric(

              horizontal:

                  18,

              vertical:

                  12,

            ),



        child:

            Row(

          mainAxisSize:

              MainAxisSize.min,



          children: List.generate(

            3,

            (index){



              return AnimatedBuilder(

                animation:

                    controller,



                builder:

                    (context,child){



                  return Container(

                    margin:

                        const EdgeInsets.symmetric(

                          horizontal:

                              4,

                        ),



                    width:

                        8,



                    height:

                        8,



                    decoration:

                        BoxDecoration(

                      color:

                          Colors.white.withValues(

                            alpha:

                                .4 +

                                (

                                  controller.value *

                                  .4

                                ),

                          ),



                      shape:

                          BoxShape.circle,

                    ),

                  );


                },

              );


            },

          ),

        ),

      ),

    );

  }

}