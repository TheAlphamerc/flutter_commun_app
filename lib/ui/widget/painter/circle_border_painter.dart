import 'package:flutter/material.dart';

class CircleBorderPainter extends CustomPainter {
  final Color color;
  final double stroke;

  const CircleBorderPainter({this.color = Colors.black, this.stroke = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
