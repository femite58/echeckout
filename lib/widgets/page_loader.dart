import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PageLoader extends StatelessWidget {
  const PageLoader({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;
    return Container(
      width: sz.width,
      height: height ?? sz.height - 149 - 67,
      alignment: Alignment.center,
      child: const SizedBox(
        height: 40,
        width: 40,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primCol),
            strokeWidth: 4,
          ),
        ),
      ),
    );
  }
}
