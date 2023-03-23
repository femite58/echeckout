import 'package:flutter/material.dart';

class CusSnackBar {
  static showSnackBar(
    ctx,
    content, {
    double? width,
    EdgeInsetsGeometry? padding,
    Animation<double>? anim,
  }) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: width ?? MediaQuery.of(ctx).size.width * .7,
        backgroundColor: Theme.of(ctx).primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: 4,
        ),
        animation: anim,
      ),
    );
  }
}
