import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'buttons.dart';
// import 'modal_close.dart';
import 'modal_container.dart';

class ConfirmModal extends StatelessWidget {
  const ConfirmModal({
    super.key,
    required this.title,
    required this.body,
    required this.action,
    this.yesTxt = 'Cancel',
    this.noTxt = 'Confirm',
  });
  final String title;
  final String body;
  final VoidCallback action;
  final String yesTxt;
  final String noTxt;

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const ModalClose(),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: body.isEmpty ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.secCol,
            ),
          ),
          const SizedBox(height: 25),
          if (body.isNotEmpty)
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppTheme.fontSize,
                color: Color(0xFF788190),
              ),
            ),
          const SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: Button(
                  type: 'primBtnOutline',
                  tapFunc: () => Navigator.of(context).pop(),
                  text: noTxt,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Button(
                  type: 'primBtn',
                  tapFunc: () {
                    Navigator.of(context).pop();
                    action();
                  },
                  text: yesTxt,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
