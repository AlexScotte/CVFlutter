import 'dart:math';
import 'package:flutter/material.dart';

class CircleWidget extends CustomPainter {
  bool isFirst = false;
  bool isLast = false;

  Color circleColor = Colors.black;
  bool isStroke = true;
  double strokeWidth = 2;

  CircleWidget(
      {this.circleColor,
      this.isStroke,
      this.strokeWidth,
      this.isFirst,
      this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = circleColor
      ..strokeWidth = strokeWidth
      ..style = isStroke ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // draw circle
    Offset center = new Offset(size.width / 2, size.height / 2);
    var minimum = min(size.width / 2, size.height / 2);
    var radius = minimum - 10;
    canvas.drawCircle(center, radius, paint);

    if (!isFirst) {
      // draw top line
      Offset startingPoint = new Offset(size.width / 2, 0);
      Offset endingPoint =
          new Offset(size.width / 2, (size.height / 2) - radius);
      canvas.drawLine(startingPoint, endingPoint, paint);
    }

    if (!isLast) {
      //draw bottom line
      Offset startingPoint = Offset(size.width / 2, (size.height / 2) + radius);
      Offset endingPoint = Offset(size.width / 2, (size.height));
      canvas.drawLine(startingPoint, endingPoint, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
