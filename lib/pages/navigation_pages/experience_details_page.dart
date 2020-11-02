import 'package:cvflutter/app_localizations.dart';
import 'package:cvflutter/helpers/widget_helper.dart';
import 'package:cvflutter/model/client.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: _buildBodyPage(client),
    );
  }

  Widget _buildBodyPage(Client client) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () async {
                      if (await canLaunch(client.site))
                        await launch(client.site);
                    },
                    child: new Container(
                        width: 200.0,
                        height: 75.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: new NetworkImage(client.imageUrl))))),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(client.experience.job.toUpperCase(),
                                    style: Theme.of(context).textTheme.title),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                if (client.experience.duration != null &&
                                    client.experience.duration.isNotEmpty)
                                  new Text(
                                    "(${client.experience.duration})",
                                  ),
                              ])
                        ]),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    _buildContextRow(client),
                    _buildMissionRow(client),
                    new Text(
                        AppLocalizations.of(context)
                            .translate('xp_details_skills'),
                        style: Theme.of(context).textTheme.title),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    WidgetHelper.buildChips(
                        context,
                        client.experience.skills
                            .map<String>((sk) => sk.name)
                            .toList()),
                  ]),
            ),
          ],
        ));
  }

  Widget _buildContextRow(Client client) {
    var children = new List<Widget>();
    if (client.experience.details.context != null &&
        client.experience.details.context.isNotEmpty) {
      children.add(new Text(
          AppLocalizations.of(context).translate('xp_details_context'),
          style: Theme.of(context).textTheme.title));
      children.add(Padding(padding: EdgeInsets.only(top: 20.0)));
      children.add(
          new Text(client.experience.details.context.replaceAll("\\n", "\n")));
      children.add(Padding(padding: EdgeInsets.only(top: 30.0)));
    }

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _buildMissionRow(Client client) {
    var children = new List<Widget>();
    if (client.experience.details.missions != null &&
        client.experience.details.missions.isNotEmpty) {
      children.add(new Text(
          AppLocalizations.of(context).translate('xp_details_mission'),
          style: Theme.of(context).textTheme.title));
      children.add(Padding(padding: EdgeInsets.only(top: 20.0)));
      children.add(
          new Text(client.experience.details.missions.replaceAll("\\n", "\n")));
      children.add(Padding(padding: EdgeInsets.only(top: 30.0)));
    }

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
