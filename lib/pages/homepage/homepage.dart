import 'package:cvflutter/notifiers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Switch(
          value: Provider.of<AppStateNotifier>(context).isDarkMode,
          onChanged: (boolVal) {
            Provider.of<AppStateNotifier>(context).updateTheme(boolVal);
          },
        ),
      ),
    );
  }
}
