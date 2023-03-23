import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons extends StatelessWidget {
  const SvgIcons(this.name, {super.key, this.size});
  final String name;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
    );
  }
}
