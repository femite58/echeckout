import 'package:flutter/material.dart';

class ModalContainer extends StatelessWidget {
  const ModalContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(21),
      margin: const EdgeInsets.all(10),
      child: child,
    );
  }
}
