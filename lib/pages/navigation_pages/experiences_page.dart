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
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget _buildListPanel(List<Company> companies) {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            companies[index].isExpanded = !isExpanded;
          });
        },
        children: companies.map<ExpansionPanel>((Company company) {
          return _buildHeader(company);
        }).toList());
  }

  ExpansionPanel _buildHeader(Company company) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(company.name),
          );
        },
        body: _buildChildren(company.clients),
        canTapOnHeader: true,
        isExpanded: company.isExpanded);
  }

  Widget _buildChildren(List<Client> clients) {
    return new Column(
        children: clients.map<Widget>((Client client) {
      return ListTile(
        title: Text(client.name),
        subtitle: Text(client.location),
      );
    }).toList());
  }
}
