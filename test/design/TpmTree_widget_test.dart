import 'package:flutter/material.dart';
import 'package:tpm/design/TpmTree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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
  testWidgets("Flutter Widget Test", (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
      child: MediaQuery(
        data: MediaQueryData(),
        child: TpmTree(TestBuilder(), <TreeItem<TestContent>>[].obs),
      ),
      textDirection: TextDirection.ltr,
    ));
    expect(find.text('Első'), findsOneWidget);
  });
}
