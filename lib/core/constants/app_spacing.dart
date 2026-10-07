import 'package:flutter/material.dart';

 
abstract final class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

   static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
  static const EdgeInsets card = EdgeInsets.all(sm);
  static const EdgeInsets cardContent = EdgeInsets.fromLTRB(sm, sm, sm, xs);
  static const EdgeInsets field = EdgeInsets.symmetric(
    horizontal: md,
    vertical: md,
  );
  static const EdgeInsets buttonContent = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}
