import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  final BuildContext context;
  final Offset center;

  final double radius;
  final Color color;
  Paint _paint;

  DrawCircle(
      {@required this.context,
        this.center = Offset.zero,
        this.radius = 100.0,
        this.color = Colors.red}) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}