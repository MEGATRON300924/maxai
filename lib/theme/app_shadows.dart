import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x10000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 32,
      offset: Offset(0, 16),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 40,
      offset: Offset(0, 20),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x1A2563EB),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x332563EB),
      blurRadius: 30,
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> glowStrong = [
    BoxShadow(
      color: Color(0x662563EB),
      blurRadius: 60,
      spreadRadius: 8,
    ),
  ];

  static const List<BoxShadow> glass = [
    BoxShadow(
      color: Color(0x10FFFFFF),
      blurRadius: 18,
      spreadRadius: 1,
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> dialog = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 36,
      offset: Offset(0, 18),
    ),
  ];
}