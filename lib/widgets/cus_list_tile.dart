import 'package:flutter/material.dart';

import '../icons/custom_icons_icons.dart';
import '../theme/app_theme.dart';

class CusListTile extends StatelessWidget {
  const CusListTile({
    super.key,
    required this.tapFunc,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final VoidCallback tapFunc;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunc,
      child: Container(
        // height: 90,
        constraints: const BoxConstraints(minHeight: 85),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE6E8EB),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(4, 6, 15, 0.05),
              offset: Offset(0, 4),
              blurRadius: 60,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          // vertical: 16,
          horizontal: 18,
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8F1FF),
              ),
              width: 46,
              height: 46,
              alignment: Alignment.center,
              child: Icon(icon, color: AppTheme.primCol),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF011B33),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    subtitle,
                    // overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF788190),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              CustomIcons.right_open_1,
              color: AppTheme.primCol,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
