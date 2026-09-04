import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/glass_card.dart';
import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';


class MaxHomeCard extends StatelessWidget {

  const MaxHomeCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final home =
        context.watch<HomeProvider>();

    final maxHome =
        home.maxHome;


    String title;

    String subtitle;

    IconData icon;


    if (!maxHome.isInstalled) {

      title =
          "Download MAX Home";

      subtitle =
          "Control your smart home with MAX";

      icon =
          Icons.home_outlined;


    } else if (!maxHome.isLinked) {

      title =
          "Link MAX Home";

      subtitle =
          "Connect your MAX Home account";

      icon =
          Icons.link;


    } else if (
        maxHome.onlineDevices == 0 &&
        maxHome.offlineDevices == 0
    ) {

      title =
          "No devices added yet";

      subtitle =
          "Add your first smart device";

      icon =
          Icons.devices_other;


    } else {

      title =
          "${maxHome.onlineDevices + maxHome.offlineDevices} Devices";


      subtitle =
          "${maxHome.onlineDevices} Online • ${maxHome.offlineDevices} Offline";


      icon =
          Icons.home_work_outlined;

    }


    return GlassCard(

      borderRadius:
          BorderRadius.circular(26),


      padding:
          const EdgeInsets.all(
            AppSpacing.cardPadding,
          ),


      onTap: () {

      },


      child: Row(

        children: [

          Container(

            width:
                52,

            height:
                52,


            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(18),


              gradient:
                  AppColors.accentGradient,

            ),


            child: Icon(

              icon,

              color:
                  Colors.white,

              size:
                  28,

            ),

          ),


          const SizedBox(
            width:
                AppSpacing.md,
          ),


          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [

                Text(

                  "MAX Home",

                  style:
                      AppTypography.labelMedium.copyWith(

                    color:
                        AppColors.darkTextSecondary,

                  ),

                ),


                const SizedBox(
                  height:
                      AppSpacing.xs,
                ),


                Text(

                  title,

                  style:
                      AppTypography.titleMedium.copyWith(

                    color:
                        AppColors.darkTextPrimary,

                  ),

                ),


                const SizedBox(
                  height:
                      AppSpacing.xs,
                ),


                Text(

                  subtitle,

                  style:
                      AppTypography.bodySmall.copyWith(

                    color:
                        AppColors.darkTextSecondary,

                  ),

                ),

              ],

            ),

          ),


          const Icon(

            Icons.arrow_forward_ios,

            size:
                16,

            color:
                AppColors.darkTextHint,

          ),

        ],

      ),

    );

  }

}