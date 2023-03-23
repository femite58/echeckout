import 'package:flutter/material.dart';

class ModalController {
  static showModal(
    ctx,
    modal, {
    dismissible = true,
  }) {
    return showModalBottomSheet(
      context: ctx,
      builder: (_) => modal,
      barrierColor: const Color(0xBE011B33),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
    );
  }
}
