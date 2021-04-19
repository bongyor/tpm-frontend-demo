import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'TpmTreePrefixPainter.dart';

class TreeItem<Content> {
  final List<TreeItem<Content>> children;
  final Content content;

  TreeItem(this.content, {this.children = const []});
}

class TreeItemState<Content> {
  final List<TreeItemState<Content>> children;
  final Content content;
  final RxBool opened = true.obs;

  hasChildren() => children.isNotEmpty;

  TreeItemState(this.content, {this.children = const []});
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
  final bool hasChildren;

  TpmTreeRenderItem(this.szulok, this.content, this.opened, this.hasChildren);
}

class TpmTree<Content> extends StatelessWidget {
  final Controller<Content> controller = Controller<Content>();
  final List<TreeItem<Content>> children;
  final TpmTreeItemWidgetBuilderBase<Content> builder;
  final double spaceing;
  final double rowHeight;
  final double leadColumnWidth;

  TpmTree(
    this.builder,
    this.children, {
    this.spaceing = 24,
    this.rowHeight = 25,
    this.leadColumnWidth = 200,
  }) {
    controller.initContent(children);
  }

  Widget build(BuildContext context) => Obx(
        () => Column(
          children: <Widget>[buildHeader()] +
              buildTreeItems(controller.renderedContent),
        ),
      );

  Row buildHeader() => Row(
        children: <Widget>[
              Container(
                width: leadColumnWidth,
              )
            ] +
            expandColumns(builder.buildDataHeaders()),
      );

  List<Widget> buildTreeItems(List<TpmTreeRenderItem> flatChildren) =>
      flatChildren
          .map(
            (renderItem) => Container(
              child: Row(
                children: <Widget>[buildLeadColumn(renderItem)] +
                    expandColumns(builder.buildDataColumns(renderItem.content)),
              ),
            ),
          )
          .toList();

  Container buildLeadColumn(TpmTreeRenderItem renderItem) => Container(
        width: leadColumnWidth,
        child: Row(
          children: [
            Container(
              // color: Colors.lightGreen,
              width: renderItem.szulok.length * spaceing,
              height: rowHeight,
              child: CustomPaint(
                painter: TpmTreePrefixPainter(renderItem.szulok, spaceing),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: spaceing,
              height: rowHeight,
              child: buildLeadColumnIconButton(renderItem),
            ),
            SizedBox(
              child: builder.buildLeadColumn(renderItem.content),
              height: rowHeight,
            ),
          ],
        ),
      );

  Widget buildLeadColumnIconButton(TpmTreeRenderItem renderItem) =>
      renderItem.hasChildren
          ? IconButton(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.zero,
              icon: Obx(
                () => Icon(
                  renderItem.opened.value
                      ? Icons.arrow_drop_down
                      : Icons.arrow_right,
                ),
              ),
              onPressed: () {
                renderItem.opened.toggle();
                controller.refreshRenderedContent();
              },
            )
          : Container();

  List<Widget> expandColumns(List<Widget> columns) => columns
      .expand((element) => [
            Container(width: spaceing),
            Container(width: spaceing * 5, child: element),
          ])
      .toList();
}

class Controller<Content> extends GetxController {
  RxList<TpmTreeRenderItem<Content>> renderedContent =
      RxList<TpmTreeRenderItem<Content>>();
  List<TreeItemState<Content>> contentState;

  initContent(List<TreeItem<Content>> treeItems) {
    contentState = treeItems.map((e) => _mapTreeItemToState(e)).toList();
    refreshRenderedContent();
  }

  TreeItemState<Content> _mapTreeItemToState(TreeItem<Content> item) =>
      TreeItemState(
        item.content,
        children: item.children.map((e) => _mapTreeItemToState(e)).toList(),
      );

  refreshRenderedContent() {
    renderedContent.clear();
    renderedContent.addAll(flatTreeRenderItem(contentState));
  }

  List<TpmTreeRenderItem<Content>> flatTreeRenderItem(
          List<TreeItemState<Content>> state) =>
      state.expand((element) => _flatTreeRenderItem(element)).toList();

  List<TpmTreeRenderItem<Content>> _flatTreeRenderItem(
      TreeItemState<Content> item,
      {List<TpmTreeParent> szulok = const []}) {
    final flatten = <TpmTreeRenderItem<Content>>[];
    flatten.add(TpmTreeRenderItem(
      szulok,
      item.content,
      item.opened,
      item.hasChildren(),
    ));

    if (item.opened.value) {
      for (var childIndex = 0;
          childIndex < item.children.length;
          childIndex++) {
        final child = item.children[childIndex];
        final legalso = (childIndex == item.children.length - 1);
        final orokoltSzulok = szulok.map((e) {
              if (e == TpmTreeParent.OPEN) {
                return TpmTreeParent.CLOSED;
              } else if (e == TpmTreeParent.OPEN_LAST) {
                return TpmTreeParent.EMPTY;
              } else {
                return e;
              }
            }).toList() +
            [legalso ? TpmTreeParent.OPEN_LAST : TpmTreeParent.OPEN];
        flatten.addAll(_flatTreeRenderItem(child, szulok: orokoltSzulok));
      }
    }

    return flatten;
  }
}
