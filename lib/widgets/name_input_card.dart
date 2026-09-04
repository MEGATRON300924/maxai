import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';


class NameInputCard extends StatefulWidget {

  final ValueChanged<String> onChanged;

  final String? response;


  const NameInputCard({
    super.key,
    required this.onChanged,
    this.response,
  });


  @override
  State<NameInputCard> createState() =>
      _NameInputCardState();
}



class _NameInputCardState extends State<NameInputCard> {


  final TextEditingController _controller =
      TextEditingController();


  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Column(

      children: [


        Container(

          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),


          decoration: BoxDecoration(

            color: Colors.white.withValues(
              alpha: .08,
            ),


            borderRadius: BorderRadius.circular(
              28,
            ),


            border: Border.all(
              color: AppColors.border,
            ),

          ),



          child: TextField(

            controller: _controller,


            onChanged: widget.onChanged,


            textAlign: TextAlign.center,


            style: AppTypography.titleLarge,


            decoration: InputDecoration(

              hintText: "Your name",


              hintStyle:
                  AppTypography.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),


              border: InputBorder.none,

            ),

          ),

        ),



        AnimatedSwitcher(

          duration: const Duration(
            milliseconds: 350,
          ),


          child: widget.response == null
              ? const SizedBox(
                  height: 0,
                )

              : Padding(

                  key: ValueKey(
                    widget.response,
                  ),


                  padding: const EdgeInsets.only(
                    top: AppSpacing.md,
                  ),


                  child: Text(

                    widget.response!,


                    textAlign: TextAlign.center,


                    style:
                        AppTypography.bodyLarge.copyWith(
                      color: AppColors.primary,
                    ),

                  ),

                ),

        ),

      ],

    );
  }
}