import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        title: new Text("Mes expériences"),
      ),
      body: new Center(
        child: new Text("Experiences page"),
      ),
    );
  }
}
