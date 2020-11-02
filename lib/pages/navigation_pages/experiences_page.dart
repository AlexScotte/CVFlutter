import 'package:cvflutter/app_localizations.dart';
import 'package:cvflutter/bloc/experiences_bloc.dart';
import 'package:cvflutter/model/client.dart';
import 'package:cvflutter/model/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExperiencePage extends StatefulWidget {
  ExperiencePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final TextEditingController _searchQuery = new TextEditingController();
  ExperiencesBloc xpBloc = new ExperiencesBloc();
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
    if (_companies == null) xpBloc.fetchCompanies();

    if (!_isSearching) {
      _appBarTitle = new Text(
          AppLocalizations.of(context).translate('title_view_experiences'),
          style: Theme.of(context).textTheme.headline);
      _actionSearchIcon =
          new Icon(Icons.search, color: Theme.of(context).iconTheme.color);
      _actionIcon = _actionSearchIcon;
    }
    return new Scaffold(
      appBar: new AppBar(
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
      body: new SingleChildScrollView(
        child: StreamBuilder(
            stream: xpBloc.companies,
            builder: (context, AsyncSnapshot<List<Company>> snapshot) {
              if (snapshot.hasData) {
                _companies = snapshot.data.reversed.toList();
                return _buildListPanel(
                    _isSearching ? _buildSearchList() : _companies);
              } else if (snapshot.hasError) {
                return new Text(snapshot.error.toString());
              }
              return new Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  List<Company> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _companies;
    } else {
      var _tempCompanies = new List<Company>();

      for (var i = 0; i < _companies.length; i++) {
        var originCompany = _companies[i];
        var cloneCompany = new Company(
            clients: new List<Client>(),
            dateEnd: originCompany.dateEnd,
            dateStart: originCompany.dateStart,
            department: originCompany.department,
            id: originCompany.id,
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
    _actionIcon = new Icon(
      Icons.close,
      color: Theme.of(context).iconTheme.color,
    );
    _appBarTitle = new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: new Icon(
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
            child: new TextField(
          controller: _searchQuery,
          style: Theme.of(context).textTheme.headline,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.grey[400]),
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
