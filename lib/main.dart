import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tpm/design/TpmTree.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TPMDemo());
}

class TPMDemo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TPM demó',
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TPM demó"),
        ),
        body: TpmTree());
  }
}