import 'package:flutter/material.dart';

Route createBTTSlideRoute({required Widget page}) {
  return createSlideRoute(page, const Offset(0.0, 1.0));
}

Route createRTLSlideRoute({required Widget page}) {
  return createSlideRoute(page, const Offset(1.0, 0.0));
}

Route createSlideRoute(Widget page, Offset beginOffset) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, _, child) {
      final tween = Tween(
        begin: beginOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.ease));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
