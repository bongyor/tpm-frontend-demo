import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:tpm/design/TpmTree.dart';
import 'package:tpm/design/TpmTreePrefixPainter.dart';

class TestContent {
  final String title;
  final String elso;

  TestContent({
    this.elso = '',
    this.title = '',
  });
}

class TestBuilder extends TpmTreeItemWidgetBuilderBase<TestContent> {
  @override
  List<Widget> buildDataHeaders() => [
        Text('Első'),
      ];

  @override
  List<Widget> buildDataColumns(TestContent content) => [
        Text(content.elso),
      ];

  @override
  Widget buildLeadColumn(TestContent content) => Text(content.title);
}

void main() {
  test('Gyerekek kiteregetése', () {
    final controller = Controller<TestContent>();
    final flattenChilds = controller.flatTreeRenderItem([
      TreeItemState(TestContent()),
      TreeItemState(TestContent(), children: [
        TreeItemState(TestContent()),
        TreeItemState(
          TestContent(),
          children: [
            TreeItemState(TestContent(), children: [
              TreeItemState(TestContent()),
              TreeItemState(TestContent()),
              TreeItemState(TestContent()),
            ]),
            TreeItemState(TestContent(), children: [
              TreeItemState(TestContent()),
              TreeItemState(TestContent()),
              TreeItemState(TestContent()),
            ]),
            TreeItemState(TestContent(), children: [
              TreeItemState(TestContent()),
              TreeItemState(TestContent()),
              TreeItemState(TestContent()),
            ]),
          ],
        ),
        TreeItemState(TestContent()),
      ]),
      TreeItemState(TestContent()),
    ]);
    expect(flattenChilds.length, 18);
    expect(flattenChilds.first.szulok, []);
    expect(flattenChilds[2].szulok, [TpmTreeParent.OPEN]);
    expect(flattenChilds[16].szulok, [TpmTreeParent.OPEN_LAST]);
    expect(flattenChilds[5].szulok,
        [TpmTreeParent.CLOSED, TpmTreeParent.CLOSED, TpmTreeParent.OPEN]);
    expect(
        flattenChilds[8].szulok, [TpmTreeParent.CLOSED, TpmTreeParent.OPEN]);
    expect(flattenChilds[13].szulok,
        [TpmTreeParent.CLOSED, TpmTreeParent.EMPTY, TpmTreeParent.OPEN]);
    expect(flattenChilds[15].szulok, [
      TpmTreeParent.CLOSED,
      TpmTreeParent.EMPTY,
      TpmTreeParent.OPEN_LAST
    ]);
    expect(flattenChilds[16].szulok, [TpmTreeParent.OPEN_LAST]);
  });
}
