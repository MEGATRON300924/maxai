import 'package:flutter/material.dart';

import '../core/app_colors.dart';



class MaxLoading extends StatelessWidget {

  final double size;


  const MaxLoading({

    super.key,

    this.size = 28,

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(

      width:
          size,

      height:
          size,


      child:
          CircularProgressIndicator(

        strokeWidth:
            2.5,


        color:
            AppColors.primary,

      ),

    );

  }

}