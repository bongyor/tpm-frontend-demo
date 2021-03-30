import 'package:flutter/material.dart';

class TpmTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<TpmTreeParent>> tesztlista = [
      [],
      [TpmTreeParent.NYITOTT],
      [TpmTreeParent.ZART, TpmTreeParent.NYITOTT],
      [TpmTreeParent.ZART, TpmTreeParent.ZART, TpmTreeParent.NYITOTT],
      [TpmTreeParent.ZART, TpmTreeParent.ZART, TpmTreeParent.NYITOTT_LEGALSO],
      [TpmTreeParent.ZART, TpmTreeParent.NYITOTT],
      [TpmTreeParent.ZART, TpmTreeParent.ZART, TpmTreeParent.NYITOTT_LEGALSO],
      [TpmTreeParent.ZART, TpmTreeParent.ZART, TpmTreeParent.URES, TpmTreeParent.NYITOTT_LEGALSO],
      [TpmTreeParent.ZART, TpmTreeParent.NYITOTT_LEGALSO],
      [TpmTreeParent.NYITOTT_LEGALSO],
      [TpmTreeParent.URES, TpmTreeParent.NYITOTT_LEGALSO],
    ];
    return Column(
      children: tesztlista
          .map(
            (szulok) => Container(
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        Container(
                            // color: Colors.lightGreen,
                            width: szulok.length * 20.0,
                            height: 20.0,
                            child: CustomPaint(
                              painter: TpmTreePrefixPainter(szulok),
                              child: Container(),
                            )),
                        Text('Sor megnevezése'),
                      ],
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Text('Második oszlop'),
                  Container(
                    width: 20,
                  ),
                  Text('Harmadik oszlop')
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

enum TpmTreeParent { ZART, NYITOTT_LEGALSO, URES, NYITOTT }

class TpmTreePrefixPainter extends CustomPainter {
  final int egySzuloSzelessege = 20;
  final List<TpmTreeParent> szulok;

  TpmTreePrefixPainter(this.szulok);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    double startPoint = 5;
    for (var szulo in szulok) {
      switch (szulo) {
        case TpmTreeParent.ZART:
          fuggolegesVonal(startPoint, 0, size.height, canvas, paint);
          break;
        case TpmTreeParent.NYITOTT:
          fuggolegesVonal(startPoint, 0, size.height, canvas, paint);
          vizszintesVonal(size.height / 2, startPoint, startPoint + (egySzuloSzelessege / 2), canvas, paint);
          break;
        case TpmTreeParent.NYITOTT_LEGALSO:
          fuggolegesVonal(startPoint, 0, size.height / 2, canvas, paint);
          vizszintesVonal(size.height / 2, startPoint, startPoint + (egySzuloSzelessege / 2), canvas, paint);
          break;
        case TpmTreeParent.URES:
          break;
      }
      startPoint += egySzuloSzelessege;
    }
  }

  void fuggolegesVonal(double x, double yMin, double yMax, Canvas canvas, Paint paint) {
    Offset startingPoint = Offset(x, yMin);
    Offset endingPoint = Offset(x, yMax);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void vizszintesVonal(double y, double xMin, double xMax, Canvas canvas, Paint paint) {
    Offset startingPoint = Offset(xMin, y);
    Offset endingPoint = Offset(xMax, y);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }
}
