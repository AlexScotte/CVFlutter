import 'package:cvflutter/model/client.dart';
import 'package:flutter/material.dart';

class ExperienceDetailsPage extends StatefulWidget {
  ExperienceDetailsPage({Key key, @required this.client}) : super(key: key);
  final Client client;

  @override
  _ExperienceDetailsPageState createState() => _ExperienceDetailsPageState();
}

class _ExperienceDetailsPageState extends State<ExperienceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var client = widget.client;

    return new Scaffold(
      appBar: AppBar(
          title: new Text(
            client.name.toUpperCase(),
            style: Theme.of(context).textTheme.headline,
          ),
          iconTheme: Theme.of(context).iconTheme),
      body: new Center(child: new Text("")),
    );
  }
}
