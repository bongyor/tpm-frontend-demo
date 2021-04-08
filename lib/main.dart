import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tpm/design/TpmTree.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TPMDemo());
}

class DemoContent {
  final String title;
  final int elso;
  final String masodik;
  final String harmadik;
  final String negyedik;
  final String otodik;

  DemoContent({
    this.elso = 1,
    this.masodik = 'Második',
    this.harmadik = 'Harmadik',
    this.negyedik = 'Negyedik',
    this.otodik = 'Ötödik',
    this.title = 'Cím',
  });
}

class DemoBuilder extends TpmTreeItemWidgetBuilderBase<DemoContent> {
  @override
  List<Widget> buildDataColumns(DemoContent content) {
    Icon elsoIkon;
    if (content.elso % 2 == 0) {
      elsoIkon = Icon(Icons.ac_unit, color: Colors.red);
    } else {
      elsoIkon = Icon(Icons.add_photo_alternate_outlined, color: Colors.green);
    }
    final elsoCella = Row(
      children: [elsoIkon, Text(content.elso.toString())],
    );

    return [
      elsoCella,
      Text(content.masodik),
      Text(content.harmadik),
      Text(content.negyedik),
      Text(content.otodik),
    ];
  }

  @override
  List<Widget> buildDataHeaders() => [
        Text('Első'),
        Text('Második'),
        Text('Harmadik'),
        Text('Negyedik'),
        Text('Ötödik'),
      ];

  @override
  Widget buildLeadColumn(DemoContent content) => Container(
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 6,
            ),
            Container(width: 5),
            Icon(
              Icons.folder,
              size: 15,
              color: Colors.blueGrey,
            ),
            Container(width: 5),
            Text(content.title)
          ],
        ),
        color: Colors.white10,
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(5),
        alignment: Alignment.centerLeft,
      );
}

class TPMDemo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TPM demó',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: Locale('hu', 'HU'),
      supportedLocales: [Locale('hu', 'HU')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<TreeItem<DemoContent>> content = [
    TreeItem(DemoContent(elso: 1)),
    TreeItem(DemoContent(elso: 2), children: [
      TreeItem(DemoContent(elso: 3)),
      TreeItem(
        DemoContent(elso: 4),
        children: [
          TreeItem(DemoContent(elso: 5), children: [
            TreeItem(DemoContent(elso: 6)),
            TreeItem(DemoContent(elso: 7)),
            TreeItem(DemoContent(elso: 8)),
          ]),
          TreeItem(DemoContent(elso: 9), children: [
            TreeItem(DemoContent(elso: 10)),
            TreeItem(DemoContent(elso: 11)),
            TreeItem(DemoContent(elso: 12)),
          ]),
          TreeItem(DemoContent(elso: 13), children: [
            TreeItem(DemoContent(elso: 14)),
            TreeItem(DemoContent(elso: 15)),
            TreeItem(DemoContent(elso: 16)),
          ]),
        ],
      ),
      TreeItem(DemoContent(elso: 17)),
    ]),
    TreeItem(DemoContent(elso: 18)),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TPM demó"),
      ),
      body: TpmTree(
        DemoBuilder(),
        content,
      ),
    );
  }
}
