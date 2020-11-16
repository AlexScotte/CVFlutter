import 'package:cvflutter/app_localizations.dart';
import 'package:cvflutter/bloc/experiences_bloc.dart';
import 'package:cvflutter/helpers/widget_helper.dart';
import 'package:cvflutter/model/client.dart';
import 'package:cvflutter/model/company.dart';
import 'package:cvflutter/pages/navigation_pages/experience_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExperiencePage extends StatefulWidget {
  ExperiencePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final TextEditingController _searchQuery = TextEditingController();
  ExperiencesBloc _xpBloc = ExperiencesBloc();
  List<Company> _companies;
  Icon _actionIcon;
  Icon _actionSearchIcon;
  Widget _appBarTitle;
  bool _isSearching = false;
  String _searchText = "";
  int _count = 0;

  _ExperiencePageState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_companies == null) _xpBloc.fetchCompanies(context);

    if (!_isSearching) {
      _appBarTitle = Text(
          AppLocalizations.of(context).translate('title_view_experiences'),
          style: Theme.of(context).textTheme.headline);
      _actionSearchIcon =
          Icon(Icons.search, color: Theme.of(context).iconTheme.color);
      _actionIcon = _actionSearchIcon;
    }
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _actionIcon,
            onPressed: () {
              setState(() {
                if (_actionIcon.icon == Icons.search) {
                  _searchIconClicked();
                } else {
                  _resetTextIconClicked();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _xpBloc.companies,
            builder: (context, AsyncSnapshot<List<Company>> snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                _companies = snapshot.data.reversed.toList();
                return _buildListPanel(
                    _isSearching ? _buildSearchList() : _companies);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(child: CircularProgressIndicator()));
            }),
      ),
    );
  }

  List<Company> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _companies;
    } else {
      var _tempCompanies = List<Company>();

      for (var i = 0; i < _companies.length; i++) {
        var originCompany = _companies[i];
        var cloneCompany = Company(
            clients: List<Client>(),
            dateEnd: originCompany.dateEnd,
            dateStart: originCompany.dateStart,
            department: originCompany.department,
            job: originCompany.job,
            name: originCompany.name,
            town: originCompany.town);
        cloneCompany.isExpanded = originCompany.isExpanded;

        var originClients = originCompany.clients
            .where((c) => c.name.toLowerCase() != "perso")
            .toList();

        for (var j = 0; j < originClients.length; j++) {
          var originClient = originClients[j];
          bool isMatching = originClient.experience?.skills?.any((sk) =>
              sk.name.toLowerCase().contains(_searchText.toLowerCase()));
          if (isMatching) {
            cloneCompany.clients.add(originClient);
          }
        }

        if (cloneCompany.clients.isNotEmpty) {
          _tempCompanies.add(cloneCompany);
        }
      }
      return _tempCompanies;
    }
  }

  void _searchIconClicked() {
    _actionIcon = Icon(
      Icons.close,
      color: Theme.of(context).iconTheme.color,
    );
    _appBarTitle = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery.clear();
            });
          },
        ),
        Expanded(
            child: TextField(
          controller: _searchQuery,
          style: Theme.of(context).textTheme.headline,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              hintText:
                  AppLocalizations.of(context).translate('toolbar_search'),
              hintStyle: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(fontSize: 14, color: Colors.grey[400])),
        ))
      ],
    );

    setState(() {
      _isSearching = true;
    });
  }

  void _resetTextIconClicked() {
    setState(() {
      _searchQuery.clear();
    });
  }

  Widget _buildListPanel(List<Company> companies) {
    return ExpansionPanelList(
        // 01/11/20: Change the key every time the expansion panel is built
        // used to resolve this crash https://github.com/flutter/flutter/issues/13780
        key: Key("${++_count}"),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _companies[index].isExpanded = !isExpanded;
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${company.job} @ ${company.name}",
                    style: Theme.of(context).textTheme.title),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Text("(${company.dateStart} - ${company.dateEnd})",
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
    return Column(
        children: clients.reversed
            .where((c) => c.name.toLowerCase() != "perso")
            .map<Widget>((Client client) {
      return ListTile(
          onTap: () {
            this.onExperienceSelected(client);
          },
          title: Container(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(client.name,
                      style: Theme.of(context).textTheme.headline),
                  Padding(padding: EdgeInsets.only(top: 5.0)),
                  if (client.experience.duration != null &&
                      client.experience.duration.isNotEmpty)
                    Text("(${client.experience.duration})",
                        style: Theme.of(context).textTheme.subtitle),
                  WidgetHelper.buildChips(
                      context,
                      client.experience.skills
                          .where((sk) => sk.important == 1)
                          .map((sk) => sk.name)
                          .toList()),
                ]),
          ));
    }).toList());
  }

  void onExperienceSelected(Client client) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExperienceDetailsPage(
                  client: client,
                )));
  }
}
