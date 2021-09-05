import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  FadeRoute(this.widget, {this.duration = const Duration(milliseconds: 500)})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation, secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation,
              secondaryAnimation, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
//              opacity: animation,
              child: child,
            );
          },
          transitionDuration: duration,
        );

  final Widget widget;
  final Duration duration;
}
