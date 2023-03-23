import 'package:flutter/material.dart';
class DashedBorder extends CustomPainter {
  DashedBorder({
    this.color = const Color(0xFFB3BBC2),
    this.strokeWidth = 1,
    this.dashArr = const [4.0, 3.0],
  });
  final Color color;
  final double strokeWidth;
  final List dashArr;
  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    Path path = Path();
    List dash = dashArr;
    double to = 0;
    while (to <= size.width) {
      path.moveTo(to, 0);
      path.lineTo(to + dash[0], 0);
      to += dash[0] + dash[1];
    }
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}