import 'package:flutter/animation.dart';

class AppAnimation {
  AppAnimation._();

  static const Duration instant = Duration(milliseconds: 100);

  static const Duration veryFast = Duration(milliseconds: 150);

  static const Duration fast = Duration(milliseconds: 200);

  static const Duration normal = Duration(milliseconds: 300);

  static const Duration medium = Duration(milliseconds: 450);

  static const Duration slow = Duration(milliseconds: 600);

  static const Duration slower = Duration(milliseconds: 800);

  static const Duration splash = Duration(milliseconds: 1800);

  static const Duration orbBreathing = Duration(milliseconds: 2600);

  static const Duration orbPulse = Duration(milliseconds: 1800);

  static const Duration orbThinking = Duration(milliseconds: 1200);

  static const Duration orbSpeaking = Duration(milliseconds: 900);

  static const Duration loading = Duration(milliseconds: 1500);

  static const Duration pageTransition = Duration(milliseconds: 350);

  static const Duration navigation = Duration(milliseconds: 300);

  static const Duration dialog = Duration(milliseconds: 250);

  static const Duration bottomSheet = Duration(milliseconds: 300);

  static const Duration snackbar = Duration(milliseconds: 250);

  static const Duration button = Duration(milliseconds: 180);

  static const Duration textField = Duration(milliseconds: 220);

  static const Duration hover = Duration(milliseconds: 160);

  static const Duration longPress = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOutCubic;

  static const Curve emphasized = Curves.easeOutExpo;

  static const Curve decelerate = Curves.decelerate;

  static const Curve accelerate = Curves.easeIn;

  static const Curve bounce = Curves.easeOutBack;

  static const Curve smooth = Curves.easeInOut;

  static const Curve linear = Curves.linear;
}