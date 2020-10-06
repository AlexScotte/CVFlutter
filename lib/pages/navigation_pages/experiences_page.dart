import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../app_localizations.dart';

class ExperiencePage extends StatefulWidget {
  ExperiencePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            AppLocalizations.of(context).translate('title_view_experiences')),
      ),
      body: new Center(
        child: new Text("Experiences page"),
      ),
    );
  }
}
