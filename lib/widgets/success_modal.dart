import 'package:echeckout/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'modal_container.dart';

class SuccessModal extends StatelessWidget {
  const SuccessModal({
    super.key,
    this.icon,
    required this.title,
    required this.body,
    this.btnTxt,
    this.action,
    this.error = false,
  });
  final Widget? icon;
  final String title;
  final String body;
  final String? btnTxt;
  final VoidCallback? action;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 31),
        icon ??
            (error
                ? SvgPicture.asset(
                    'assets/images/errorIcon.svg',
                    width: 75,
                    height: 75,
                  )
                : SvgPicture.asset('assets/images/success-check.svg')),
        const SizedBox(height: 38),
        Container(
          width: 266,
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 266,
          alignment: Alignment.center,
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        const SizedBox(
          height: 61,
        ),
        Button(
          type: 'primBtn',
          tapFunc: () {
            Navigator.of(context).pop();
            if (action != null) action!();
          },
          text: btnTxt ?? 'OK',
        ),
      ],
    ));
  }
}
