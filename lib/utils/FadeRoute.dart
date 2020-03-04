import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute(this.page)
      : super(
    pageBuilder: (
        context,
        animation,
        secondaryAnimation,
        ) {
      return page;
    },
    transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
        ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}