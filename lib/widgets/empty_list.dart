import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    this.title = 'No records!',
    this.icon = 'assets/images/empty-record.svg',
    required this.body,
    this.vp = 50,
  });
  final String title;
  final String body;
  final String icon;
  final double vp;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: vp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 40,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.secCol,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(1, 27, 51, 0.4),
              fontSize: AppTheme.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
