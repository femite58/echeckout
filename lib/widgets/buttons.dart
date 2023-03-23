import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../theme/app_theme.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.type = 'primBtn',
    required this.tapFunc,
    required this.text,
    this.height = 55,
    this.loading = false,
    this.disabled = false,
    this.color,
    this.fg,
    this.bg,
    this.outlined = false,
  });
  final String type;
  final String text;
  final double height;
  final bool loading;
  final bool disabled;
  final Color? color;
  final Color? fg;
  final Color? bg;
  final bool outlined;
  final void Function() tapFunc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled || loading ? null : tapFunc,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: fg != null
                  ? outlined
                      ? fg as Color
                      : bg as Color
                  : type == 'primBtn' || type == 'primBtnOutline'
                      ? color ?? AppTheme.primCol
                      : const Color(0xFF008E13),
            ),
            borderRadius: BorderRadius.circular(5),
            color: bg ??
                (type == 'primBtn'
                    ? color ?? AppTheme.primCol
                    : type == 'greenBtn'
                        ? const Color(0xFF008E13)
                        : Colors.white),
          ),
          child: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      fg ??
                          (type == 'primBtn'
                              ? Colors.white
                              : color ?? AppTheme.primCol),
                    ),
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: fg ??
                        (type == 'primBtn' || type == 'greenBtn'
                            ? Colors.white
                            : color ?? AppTheme.primCol),
                  ),
                ),
        ),
      ),
    );
  }
}
