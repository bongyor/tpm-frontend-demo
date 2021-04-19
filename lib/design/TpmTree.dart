import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TreeItem<Content> {
  final List<TreeItem<Content>> children;
  final Content content;
  final RxBool opened = true.obs;

  TreeItem(this.content, {this.children = const []});
}

abstract class TpmTreeItemWidgetBuilderBase<Content> {
  Widget buildLeadColumn(Content content);

  List<Widget> buildDataColumns(Content content);

  List<Widget> buildDataHeaders();
}

class TpmTreeRenderItem<Content> {
  final List<TpmTreeParent> szulok;
  final Content content;
  final RxBool opened;

  // final TpmTreeRenderItemOpenIconState state;

  TpmTreeRenderItem(this.szulok, this.content, this.opened);
}

enum TpmTreeRenderItemOpenIconState { OPEN, CLOSED, EMPTY }

class TpmTree<Content> extends StatelessWidget {
  final RxList<TreeItem<Content>> children;
  final TpmTreeItemWidgetBuilderBase<Content> builder;
  final double spaceing;
  final double rowHeight;

  TpmTree(this.builder, this.children,
      {this.spaceing = 24, this.rowHeight = 25});

  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: <Widget>[
                Row(
                  children: <Widget>[
                        Container(
                          width: 200,
                        )
                      ] +
                      expandColumns(builder.buildDataHeaders()),
                )
              ] +
              buildTreeItems(flatTreeRenderItems(children)),
        ));
  }

  List<Widget> buildTreeItems(List<TpmTreeRenderItem> flatChildren) {
    return flatChildren
        .map(
          (renderItem) => Container(
            child: Row(
              children: <Widget>[
                    Container(
                      width: 200,
                      child: Row(
                        children: [
                          Container(
                            // color: Colors.lightGreen,
                            width: renderItem.szulok.length * spaceing,
                            height: rowHeight,
                            child: CustomPaint(
                              painter: TpmTreePrefixPainter(
                                  renderItem.szulok, spaceing),
                              child: Container(),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            alignment: Alignment.topLeft,
                            width: spaceing,
                            height: rowHeight,
                            child: IconButton(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.zero,
                              // iconSize: 20,
                              icon: Obx(
                                () => Icon(
                                  renderItem.opened.value
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_right,
                                ),
                              ),
                              onPressed: () {
                                renderItem.opened.toggle();
                                children.refresh();
                              },
                            ),
                          ),
                          SizedBox(
                            child: builder.buildLeadColumn(renderItem.content),
                            width:
                                200 - (renderItem.szulok.length + 1) * spaceing,
                            height: rowHeight,
                          ),
                        ],
                      ),
                    ),
                  ] +
                  expandColumns(builder.buildDataColumns(renderItem.content)),
            ),
          ),
        )
        .toList();
  }

  List<Widget> expandColumns(List<Widget> columns) => columns
      .expand((element) => [
            Container(width: spaceing),
            Container(width: spaceing * 5, child: element),
          ])
      .toList();

  List<TpmTreeRenderItem<Content>> flatTreeRenderItems(
          List<TreeItem<Content>> treeItems) =>
      treeItems.expand((element) => flatTreeRenderItem(element)).toList();

  List<TpmTreeRenderItem<Content>> flatTreeRenderItem(TreeItem<Content> item,
      {List<TpmTreeParent> szulok = const []}) {
    final flatten = <TpmTreeRenderItem<Content>>[];
    flatten.add(TpmTreeRenderItem(szulok, item.content, item.opened));

    if (item.opened.value) {
      for (var childIndex = 0;
          childIndex < item.children.length;
          childIndex++) {
        final child = item.children[childIndex];
        final legalso = (childIndex == item.children.length - 1);
        final orokoltSzulok = szulok.map((e) {
              if (e == TpmTreeParent.NYITOTT) {
                return TpmTreeParent.ZART;
              } else if (e == TpmTreeParent.NYITOTT_LEGALSO) {
                return TpmTreeParent.URES;
              } else {
                return e;
              }
            }).toList() +
            [legalso ? TpmTreeParent.NYITOTT_LEGALSO : TpmTreeParent.NYITOTT];
        flatten.addAll(flatTreeRenderItem(child, szulok: orokoltSzulok));
      }
    }

    return flatten;
  }
}

enum TpmTreeParent { ZART, NYITOTT_LEGALSO, URES, NYITOTT }

class TpmTreePrefixPainter extends CustomPainter {
  final double egySzuloSzelessege;
  final List<TpmTreeParent> szulok;

  TpmTreePrefixPainter(this.szulok, this.egySzuloSzelessege);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    double startPoint = 5;
    for (var szulo in szulok) {
      switch (szulo) {
        case TpmTreeParent.ZART:
          fuggolegesVonal(startPoint, 0, size.height, canvas, paint);
          break;
        case TpmTreeParent.NYITOTT:
          fuggolegesVonal(startPoint, 0, size.height, canvas, paint);
          vizszintesVonal(size.height / 2, startPoint,
              startPoint + (egySzuloSzelessege / 2), canvas, paint);
          break;
        case TpmTreeParent.NYITOTT_LEGALSO:
          fuggolegesVonal(startPoint, 0, size.height / 2, canvas, paint);
          vizszintesVonal(size.height / 2, startPoint,
              startPoint + (egySzuloSzelessege / 2), canvas, paint);
          break;
        case TpmTreeParent.URES:
          break;
      }
      startPoint += egySzuloSzelessege;
    }
  }

  void fuggolegesVonal(
      double x, double yMin, double yMax, Canvas canvas, Paint paint) {
    Offset startingPoint = Offset(x, yMin);
    Offset endingPoint = Offset(x, yMax);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void vizszintesVonal(
      double y, double xMin, double xMax, Canvas canvas, Paint paint) {
    Offset startingPoint = Offset(xMin, y);
    Offset endingPoint = Offset(xMax, y);
    canvas.drawLine(startingPoint, endingPoint, paint);
  }
}
