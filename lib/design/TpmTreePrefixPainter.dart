import 'package:flutter/material.dart';

enum TpmTreeParent { CLOSED, OPEN_LAST, EMPTY, OPEN }
class TpmTreePrefixPainter extends CustomPainter {
  final double egySzuloSzelessege;
  final List<TpmTreeParent> szulok;

  TpmTreePrefixPainter(this.szulok, this.egySzuloSzelessege);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = createPaint();
    double startPoint = 5;
    for (var szulo in szulok) {
      switch (szulo) {
        case TpmTreeParent.CLOSED:
          paintClosedParent(startPoint, size, canvas, paint);
          break;
        case TpmTreeParent.OPEN:
          paintOpenParent(startPoint, size, canvas, paint);
          break;
        case TpmTreeParent.OPEN_LAST:
          paintOpenLastParent(startPoint, size, canvas, paint);
          break;
        case TpmTreeParent.EMPTY:
          break;
      }
      startPoint += egySzuloSzelessege;
    }
  }

  Paint createPaint() {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    return paint;
  }

  void paintOpenLastParent(double startPoint, Size size, Canvas canvas, Paint paint) {
    fuggolegesVonal(startPoint, 0, size.height / 2, canvas, paint);
    vizszintesVonal(size.height / 2, startPoint,
        startPoint + (egySzuloSzelessege / 2), canvas, paint);
  }

  void paintOpenParent(double startPoint, Size size, Canvas canvas, Paint paint) {
    paintClosedParent(startPoint, size, canvas, paint);
    vizszintesVonal(size.height / 2, startPoint,
        startPoint + (egySzuloSzelessege / 2), canvas, paint);
  }

  void paintClosedParent(double startPoint, Size size, Canvas canvas, Paint paint) {
    fuggolegesVonal(startPoint, 0, size.height, canvas, paint);
  }

  void fuggolegesVonal(
      double x, double yMin, double yMax, Canvas canvas, Paint paint) {
    Offset startingPoint = Offset(x, yMin);
    Offset endingPoint = Offset(x, yMax);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  void vizszintesVonal(
      double y, double xMin, double xMax, Canvas canvas, Paint paint) {
    Offset startingPoint = Offset(xMin, y);
    Offset endingPoint = Offset(xMax, y);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}