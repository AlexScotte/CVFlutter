import 'package:cvflutter/bloc/formation_bloc.dart';
import 'package:cvflutter/model/formation.dart';
import 'package:cvflutter/widgets/circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';

class FormationsPage extends StatefulWidget {
  FormationsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FormationsPageState createState() => _FormationsPageState();
}

class _FormationsPageState extends State<FormationsPage> {
  FormationBloc _formationBloc = new FormationBloc();

  @override
  Widget build(BuildContext context) {
    _formationBloc.fetchFormations();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            AppLocalizations.of(context).translate('title_view_formation'),
            style: Theme.of(context).textTheme.headline),
      ),
      body: StreamBuilder(
          stream: _formationBloc.formations,
          builder: (context, AsyncSnapshot<List<Formation>> snapshot) {
            if (snapshot.hasData) {
              return _buildFormationListUI(snapshot.data.reversed.toList());
            } else if (snapshot.hasError) {
              return new Text(snapshot.error.toString());
            }
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: Center(child: CircularProgressIndicator()));
          }),
    );
  }

  Widget _buildFormationListUI(List<Formation> formations) {
    return new ListView.builder(
      itemCount: formations.length,
      itemBuilder: (context, index) {
        var formation = formations[index];

        String itemSubtitle =
            formation.town != null && formation.town.trim().isNotEmpty
                ? "${formation.establishment} - ${formation.town}"
                : "${formation.establishment}";

        return Row(
          children: <Widget>[
            new Text(formation.date, style: Theme.of(context).textTheme.title),
            new Center(
              child: new CustomPaint(
                  size: new Size(30, 135),
                  painter: new CircleWidget(
                      circleColor: Theme.of(context).accentColor,
                      isStroke: true,
                      strokeWidth: 3,
                      isFirst: index == 0,
                      isLast: index == formations.length - 1)),
            ),
            new Flexible(
                child: InkWell(
              onTap: () async {
                if (await canLaunch(formation.url)) await launch(formation.url);
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 30.0)),
                  new Text(formation.name,
                      style: Theme.of(context).textTheme.title),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  new Text(itemSubtitle,
                      style: Theme.of(context).textTheme.subtitle),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  if (formation.description != null &&
                      formation.description.isNotEmpty)
                    new Text(formation.description,
                        style: Theme.of(context).textTheme.body1),
                ],
              ),
            ))
          ],
        );
      },
    );
  }
}
