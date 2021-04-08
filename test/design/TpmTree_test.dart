import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:tpm/design/TpmTree.dart';

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
    final tree = TpmTree<TestContent>(TestBuilder(), []);
    final flattenChilds = tree.flatTreeRenderItems([
      TreeItem(TestContent()),
      TreeItem(TestContent(), children: [
        TreeItem(TestContent()),
        TreeItem(
          TestContent(),
          children: [
            TreeItem(TestContent(), children: [
              TreeItem(TestContent()),
              TreeItem(TestContent()),
              TreeItem(TestContent()),
            ]),
            TreeItem(TestContent(), children: [
              TreeItem(TestContent()),
              TreeItem(TestContent()),
              TreeItem(TestContent()),
            ]),
            TreeItem(TestContent(), children: [
              TreeItem(TestContent()),
              TreeItem(TestContent()),
              TreeItem(TestContent()),
            ]),
          ],
        ),
        TreeItem(TestContent()),
      ]),
      TreeItem(TestContent()),
    ]);
    expect(flattenChilds.length, 18);
    expect(flattenChilds.first.szulok, []);
    expect(flattenChilds[2].szulok, [TpmTreeParent.NYITOTT]);
    expect(flattenChilds[16].szulok, [TpmTreeParent.NYITOTT_LEGALSO]);
    expect(flattenChilds[5].szulok,
        [TpmTreeParent.ZART, TpmTreeParent.ZART, TpmTreeParent.NYITOTT]);
    expect(flattenChilds[8].szulok, [
      TpmTreeParent.ZART,
      TpmTreeParent.NYITOTT
    ]);
    expect(flattenChilds[13].szulok,
        [TpmTreeParent.ZART, TpmTreeParent.URES, TpmTreeParent.NYITOTT]);
    expect(flattenChilds[15].szulok, [
      TpmTreeParent.ZART,
      TpmTreeParent.URES,
      TpmTreeParent.NYITOTT_LEGALSO
    ]);
    expect(flattenChilds[16].szulok, [TpmTreeParent.NYITOTT_LEGALSO]);
  });
}
