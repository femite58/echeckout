import 'package:flutter/material.dart';

class CountryIcons extends StatelessWidget {
  const CountryIcons({super.key, required this.code, this.width = 26});
  final String code;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/country_icons/$code.png',
      width: width,
    );
  }
}
