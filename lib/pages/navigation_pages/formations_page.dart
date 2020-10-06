import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../app_localizations.dart';

class FormationsPage extends StatefulWidget {
  FormationsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FormationsPageState createState() => _FormationsPageState();
}

class _FormationsPageState extends State<FormationsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            AppLocalizations.of(context).translate('title_view_formation')),
      ),
      body: new Center(
        child: new Text("Formations page"),
      ),
    );
  }
}
