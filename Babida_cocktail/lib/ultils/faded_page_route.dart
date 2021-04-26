import 'package:flutter/material.dart';

class FadedPageRoute extends PageRouteBuilder {
  final Widget widget;

  FadedPageRoute({this.widget})
      : super(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) {
            return widget;
          },
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutBack,
                ),
              ),
              child: child,
            );
          },
        );
}
