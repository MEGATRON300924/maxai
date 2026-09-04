import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class MaxSvgIcon extends StatelessWidget {


  final String asset;

  final double size;

  final Color? color;



  const MaxSvgIcon({

    super.key,

    required this.asset,

    this.size = 32,

    this.color,

  });



  @override
  Widget build(BuildContext context) {


    return SvgPicture.asset(

      "assets/icons/$asset.svg",



      width:
          size,



      height:
          size,



      fit:
          BoxFit.contain,



      colorFilter:

          color == null

              ? null

              : ColorFilter.mode(

                  color!,

                  BlendMode.srcIn,

                ),

    );

  }

}