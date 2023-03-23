import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WalletInput extends StatelessWidget {
  const WalletInput({
    super.key,
    required this.focusNode,
    required this.label,
    this.onSaved,
    this.validFunc,
    this.onSubmit,
    this.isPassword = false,
    this.errMsg,
    this.onTap,
    this.mb = 0,
    this.onChanged,
    this.keybType,
    this.padding,
    this.readonly = false,
    this.initialVal,
    this.controller,
    this.icon,
    this.hasVal = false,
    this.iconSize = 19,
    this.bg,
  });
  final FocusNode focusNode;
  final String label;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validFunc;
  final Function(String?)? onSubmit;
  final bool isPassword;
  final String? errMsg;
  final VoidCallback? onTap;
  final double mb;
  final TextInputType? keybType;
  final EdgeInsetsGeometry? padding;
  final bool readonly;
  final String? initialVal;
  final TextEditingController? controller;
  final IconData? icon;
  final bool hasVal;
  final double iconSize;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: LayoutBuilder(
            builder: (ctx, cnstr) => Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: errMsg == null || errMsg!.isEmpty
                          ? focusNode.hasFocus
                              ? AppTheme.primCol
                              : const Color(0xFFA2AFC6)
                          : const Color(0xFFFF0000),
                    ),
                    color: errMsg == null || errMsg!.isEmpty
                        ? bg ??
                            (readonly
                                ? const Color(0xFFFAFAFA)
                                : const Color(0xFFFFFFFF))
                        : const Color(0x01FF0000),
                  ),
                  padding: padding ??
                      EdgeInsets.fromLTRB(icon == null ? 17 : 42, 0, 17, 0),
                  alignment: Alignment.center,
                  height: 50,
                  child: TextFormField(
                    focusNode: focusNode,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: label,
                      hintStyle: const TextStyle(
                        color: Color(0xFFC3CFD9),
                      ),
                    ),
                    onFieldSubmitted: onSubmit,
                    onSaved: onSaved,
                    readOnly: readonly,
                    controller: controller,
                    keyboardType: keybType,
                    validator: validFunc,
                    onTap: onTap,
                    initialValue: initialVal,
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  top: cnstr.biggest.height * .5,
                  left: 16,
                  child: FractionalTranslation(
                    translation: const Offset(0, -0.5),
                    child: Container(
                      alignment: Alignment.center,
                      width: 17,
                      height: 17,
                      child: FittedBox(
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: hasVal
                              ? const Color(0xFF011b33)
                              : const Color(0xFFC3CFD9),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errMsg != null && errMsg!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            '$errMsg',
            style: const TextStyle(
              color: Color(0xFFFF0000),
              fontSize: 14,
            ),
          ),
        ],
        SizedBox(height: mb),
      ],
    );
  }
}
