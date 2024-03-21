import 'package:flutter/material.dart';

enum SlideRouteFrom { bottom, top, left, right }

PageRouteBuilder<dynamic> slideRoute(
  Widget page, {
  SlideRouteFrom from = SlideRouteFrom.right,
}) {
  Offset begin;
  Offset end;
  switch (from) {
    case SlideRouteFrom.bottom:
      begin = const Offset(0.0, 1.0);
      end = Offset.zero;
      break;
    case SlideRouteFrom.top:
      begin = const Offset(0.0, -1.0);
      end = Offset.zero;
      break;
    case SlideRouteFrom.left:
      begin = const Offset(-1.0, 0.0);
      end = Offset.zero;
      break;
    case SlideRouteFrom.right:
    default:
      begin = const Offset(1.0, 0.0);
      end = Offset.zero;
      break;
  }

  return PageRouteBuilder(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
