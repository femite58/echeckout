import 'package:flutter/material.dart';

import '../icons/custom_icons_icons.dart';

class CusCheckbox extends StatelessWidget {
  const CusCheckbox({
    super.key,
    required this.tapFunc,
    required this.checked,
    required this.label,
    this.color = const Color(0xFF1565D8),
    this.gap = 11,
  });
  final VoidCallback tapFunc;
  final Widget label;
  final bool checked;
  final Color color;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunc,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: checked ? color : const Color(0xFFA2AFC6),
              ),
              color: checked ? color : Colors.transparent,
            ),
            width: 20,
            height: 20,
            child: !checked
                ? null
                : const FittedBox(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
          ),
          SizedBox(width: gap),
          label,
        ],
      ),
    );
  }
}
