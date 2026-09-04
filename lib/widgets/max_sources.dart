import 'package:flutter/material.dart';

import 'liquid_glass_container.dart';



class MaxSources extends StatelessWidget {


  final List<String> sources;



  const MaxSources({

    super.key,

    required this.sources,

  });



  @override
  Widget build(BuildContext context) {


    if(sources.isEmpty){

      return const SizedBox();

    }



    return Padding(

      padding:

          const EdgeInsets.only(
            top:
                12,
          ),



      child:

          LiquidGlassContainer(

        radius:
            18,



        child:

            Padding(

          padding:

              const EdgeInsets.all(
                12,
              ),



          child:

              Column(

            crossAxisAlignment:

                CrossAxisAlignment.start,



            children: [



              const Text(

                "Sources",

                style:

                    TextStyle(

                  color:
                      Colors.white,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),



              const SizedBox(
                height:
                    8,

              ),



              ...sources.map(

                (source)=>

                    Text(

                      "• $source",

                      style:

                          TextStyle(

                        color:

                            Colors.white
                                .withValues(
                                  alpha:
                                      .7,
                                ),

                      ),

                    ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}