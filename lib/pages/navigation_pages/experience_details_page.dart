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

    return Scaffold(
      appBar: AppBar(
          title: Text(
            client.name.toUpperCase(),
            style: Theme.of(context).textTheme.headline2,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () async {
                      if (await canLaunch(client.site))
                        await launch(client.site);
                    },
                    child: Container(
                        width: 200.0,
                        height: 75.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: NetworkImage(client.imageUrl))))),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(client.experience.job.toUpperCase(),
                                    style: Theme.of(context).textTheme.caption),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                if (client.experience.duration != null &&
                                    client.experience.duration.isNotEmpty)
                                  Text(
                                    "(${client.experience.duration})",
                                  ),
                              ])
                        ]),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    _buildContextRow(client),
                    _buildMissionRow(client),
                    Text(
                        AppLocalizations.of(context)
                            .translate('xp_details_skills'),
                        style: Theme.of(context).textTheme.caption),
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
    var children = List<Widget>();
    if (client.experience.details.context != null &&
        client.experience.details.context.isNotEmpty) {
      children.add(Text(
          AppLocalizations.of(context).translate('xp_details_context'),
          style: Theme.of(context).textTheme.caption));
      children.add(Padding(padding: EdgeInsets.only(top: 20.0)));
      children
          .add(Text(client.experience.details.context.replaceAll("\\n", "\n")));
      children.add(Padding(padding: EdgeInsets.only(top: 30.0)));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _buildMissionRow(Client client) {
    var children = List<Widget>();
    if (client.experience.details.missions != null &&
        client.experience.details.missions.isNotEmpty) {
      children.add(Text(
          AppLocalizations.of(context).translate('xp_details_mission'),
          style: Theme.of(context).textTheme.caption));
      children.add(Padding(padding: EdgeInsets.only(top: 20.0)));
      children.add(
          Text(client.experience.details.missions.replaceAll("\\n", "\n")));
      children.add(Padding(padding: EdgeInsets.only(top: 30.0)));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
