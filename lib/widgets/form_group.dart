import 'package:flutter/material.dart';

import '../icons/custom_icons_icons.dart';
import '../theme/app_theme.dart';

class FormGroup extends StatelessWidget {
  const FormGroup({
    super.key,
    required this.focusNode,
    this.label = '',
    this.onSaved,
    this.validFunc,
    this.onSubmit,
    this.isPassword = false,
    this.errMsg,
    this.onTap,
    this.mb = 25,
    this.toggler,
    this.onChanged,
    this.keybType,
    this.padding,
    this.readonly = false,
    this.initialVal,
    this.controller,
    this.hint,
    this.textarea = false,
    this.height = 55,
    this.bg,
    this.maxlength,
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
  final Widget? toggler;
  final TextInputType? keybType;
  final EdgeInsetsGeometry? padding;
  final bool readonly;
  final bool textarea;
  final String? initialVal;
  final String? hint;
  final TextEditingController? controller;
  final double height;
  final Color? bg;
  final int? maxlength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: textarea ? 115 : height,
          child: LayoutBuilder(
            builder: (ctx, cnstr) => Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: errMsg == null || errMsg!.isEmpty
                          ? focusNode.hasFocus
                              ? AppTheme.primCol
                              : const Color(0xFFA2AFC6)
                          : const Color(0xFFFF0000),
                    ),
                    color: errMsg == null || errMsg!.isEmpty
                        ? bg ??
                            (readonly ? const Color(0xFFF8F8F8) : Colors.white)
                        : const Color(0x06FF0000),
                  ),
                  padding:
                      padding ?? const EdgeInsets.symmetric(horizontal: 19),
                  alignment: textarea ? Alignment.topCenter : Alignment.center,
                  height: textarea ? 115 : height,
                  child: TextFormField(
                    focusNode: focusNode,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                    ),
                    maxLength: maxlength,
                    onFieldSubmitted: onSubmit,
                    onSaved: onSaved,
                    readOnly: readonly,
                    controller: controller,
                    keyboardType: keybType,
                    validator: validFunc,
                    maxLines: textarea ? 5 : 1,
                    onTap: onTap,
                    initialValue: initialVal,
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (label.isNotEmpty)
                  Positioned(
                    left: 19,
                    top: 0,
                    child: FractionalTranslation(
                      translation: const Offset(0, -0.5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        color: Colors.white,
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                if (toggler != null)
                  Positioned(
                    top: cnstr.biggest.height * .5,
                    right: 5,
                    child: FractionalTranslation(
                        translation: const Offset(0, -0.5),
                        child: toggler as Widget),
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
