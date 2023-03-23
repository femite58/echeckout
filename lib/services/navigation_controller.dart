import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../icons/custom_icons_icons.dart';
import '../screens/onboarding.dart';
import '../widgets/bottom_nav.dart';

class NavigationController {
  static String? activePage;
  static Map navInfo = {};

  static slideSideways(ctx, page) {
    return Navigator.of(ctx).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var drive = animation
              .drive(Tween(begin: const Offset(1, 0), end: Offset.zero));
          var op = animation.drive(Tween(begin: 0.0, end: 1.0));
          return FadeTransition(
            opacity: op,
            child: SlideTransition(
              position: drive,
              child: child,
            ),
          );
        },
      ),
    );
  }

  static noAnimNavig(ctx, page, {settings}) {
    var mqs = MediaQuery.of(ctx).size;
    return Navigator.of(ctx).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        settings: settings,
      ),
    );
  }

  static Future slideBothSideways(ctx, enterP,
      {showNav = true, activeP, settings}) {
    activePage = activeP;
    return Navigator.of(ctx).push(
        CupertinoPageRoute(builder: (context) => enterP, settings: settings));
  }

  static Future popAndPushUntil(ctx, enterP, until, {settings}) {
    return Navigator.of(ctx).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => enterP, settings: settings),
      ModalRoute.withName(until),
    );
  }

  static replaceNav(ctx, page, route) {
    activePage = 'home';
    return Navigator.of(ctx).pushReplacement(
      CupertinoPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: route),
      ),
    );
  }
}
