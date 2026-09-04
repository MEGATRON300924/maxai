import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 30;
  static const double xxxl = 36;
  static const double pill = 999;

  static const BorderRadius radiusXS = BorderRadius.all(
    Radius.circular(xs),
  );

  static const BorderRadius radiusSM = BorderRadius.all(
    Radius.circular(sm),
  );

  static const BorderRadius radiusMD = BorderRadius.all(
    Radius.circular(md),
  );

  static const BorderRadius radiusLG = BorderRadius.all(
    Radius.circular(lg),
  );

  static const BorderRadius radiusXL = BorderRadius.all(
    Radius.circular(xl),
  );

  static const BorderRadius radiusXXL = BorderRadius.all(
    Radius.circular(xxl),
  );

  static const BorderRadius radiusXXXL = BorderRadius.all(
    Radius.circular(xxxl),
  );

  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );

  static const BorderRadius circle = BorderRadius.all(
    Radius.circular(1000),
  );
}