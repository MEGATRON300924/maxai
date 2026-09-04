import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/link_preview.dart';

import '../core/app_colors.dart';

import 'liquid_glass_container.dart';



class LinkPreviewCard extends StatelessWidget {


  final LinkPreview preview;



  const LinkPreviewCard({

    super.key,

    required this.preview,

  });



  Future<void> _openLink() async {


    final uri =
        Uri.parse(
          preview.url,
        );



    if(await canLaunchUrl(uri)) {


      await launchUrl(

        uri,

        mode:
            LaunchMode.externalApplication,

      );


    }

  }





  @override
  Widget build(BuildContext context) {


    return Padding(

      padding:

          const EdgeInsets.only(
            top:
                12,
          ),



      child:

          GestureDetector(

        onTap:
            _openLink,



        child:

            LiquidGlassContainer(

          radius:
              22,



          child:

              Column(

            crossAxisAlignment:

                CrossAxisAlignment.start,



            children: [



              if(preview.image != null)

                ClipRRect(

                  borderRadius:

                      const BorderRadius.only(

                    topLeft:
                        Radius.circular(
                          22,
                        ),

                    topRight:
                        Radius.circular(
                          22,
                        ),

                  ),



                  child:

                      Image.network(

                    preview.image!,

                    height:
                        150,

                    width:
                        double.infinity,

                    fit:
                        BoxFit.cover,

                  ),

                ),



              Padding(

                padding:

                    const EdgeInsets.all(
                      14,
                    ),



                child:

                    Column(

                  crossAxisAlignment:

                      CrossAxisAlignment.start,



                  children: [



                    Text(

                      preview.title ??
                          preview.url,



                      maxLines:
                          2,



                      overflow:

                          TextOverflow.ellipsis,



                      style:

                          const TextStyle(

                        color:
                            Colors.white,

                        fontWeight:
                            FontWeight.bold,

                        fontSize:
                            15,

                      ),

                    ),



                    const SizedBox(
                      height:
                          6,

                    ),



                    if(preview.description != null)

                      Text(

                        preview.description!,



                        maxLines:
                            3,



                        overflow:

                            TextOverflow.ellipsis,



                        style:

                            TextStyle(

                          color:

                              Colors.white
                                  .withValues(
                                    alpha:
                                        .65,
                                  ),

                          fontSize:
                              13,

                        ),

                      ),



                    const SizedBox(
                      height:
                          8,

                    ),



                    Row(

                      children: [



                        const Icon(

                          Icons.link,

                          size:
                              15,

                          color:
                              AppColors.primary,

                        ),



                        const SizedBox(
                          width:
                              5,

                        ),



                        Expanded(

                          child:

                              Text(

                            preview.url,



                            overflow:

                                TextOverflow.ellipsis,



                            style:

                                const TextStyle(

                              color:

                                  AppColors.primary,

                              fontSize:
                                  12,

                            ),

                          ),

                        ),

                      ],

                    ),

                  ],

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}