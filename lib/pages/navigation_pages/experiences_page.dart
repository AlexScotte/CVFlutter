import 'package:cvflutter/bloc/experiences_bloc.dart';
import 'package:cvflutter/model/client.dart';
import 'package:cvflutter/model/company.dart';
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
  ExperiencesBloc xpBloc = new ExperiencesBloc();
  List<Company> _companies;
  @override
  Widget build(BuildContext context) {
    if (_companies == null) xpBloc.fetchCompanies();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            AppLocalizations.of(context).translate('title_view_experiences'),
            style: Theme.of(context).textTheme.headline),
      ),
      body: new SingleChildScrollView(
        child: StreamBuilder(
            stream: xpBloc.companies,
            builder: (context, AsyncSnapshot<List<Company>> snapshot) {
              if (snapshot.hasData) {
                _companies = snapshot.data;
                return _buildListPanel(snapshot.data);
              } else if (snapshot.hasError) {
                return new Text(snapshot.error.toString());
              }
              return new Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget _buildListPanel(List<Company> companies) {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            companies.reversed.toList()[index].isExpanded = !isExpanded;
          });
        },
        children: companies.reversed.map<ExpansionPanel>((Company company) {
          return _buildHeader(company);
        }).toList());
  }

  ExpansionPanel _buildHeader(Company company) {
    return new ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return new ListTile(
            title: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("${company.job} @ ${company.name}",
                    style: Theme.of(context).textTheme.title),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                new Text("(${company.dateStart} - ${company.dateEnd})",
                    style: Theme.of(context).textTheme.subtitle),
              ],
            ),
          );
        },
        body: _buildChildren(company.clients),
        canTapOnHeader: true,
        isExpanded: company.isExpanded);
  }

  Widget _buildChildren(List<Client> clients) {
    return new Column(
        children: clients.reversed
            .where((c) => c.name.toLowerCase() != "perso")
            .map<Widget>((Client client) {
      return new ListTile(
          title: new Container(
        padding: const EdgeInsets.only(left: 0.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(client.name,
                  style: Theme.of(context).textTheme.headline),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              if (client.experience.duration != null &&
                  client.experience.duration.isNotEmpty)
                new Text("(${client.experience.duration})",
                    style: Theme.of(context).textTheme.subtitle),
              _buildChips(client.experience.skills
                  .where((sk) => sk.important == 1)
                  .map((sk) => sk.name)
                  .toList()),
            ]),
      ));
    }).toList());
  }

  Widget _buildChips(List<String> items) {
    List<Widget> chips = new List<Widget>();

    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      ChoiceChip choiceChip = ChoiceChip(
        selected: false,
        label: Text(item, style: Theme.of(context).textTheme.body2),
        shadowColor: Colors.transparent,
      );

      chips.add(choiceChip);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            spacing: 5,
            runSpacing: -10,
            children: chips,
          )
        ]);
  }
}
