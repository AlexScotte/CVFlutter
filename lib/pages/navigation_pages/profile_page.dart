import 'package:cvflutter/bloc/profile_bloc.dart';
import 'package:cvflutter/helpers/widget_helper.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/notifiers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc _profileBloc = new ProfileBloc();

  @override
  Widget build(BuildContext context) {
    _profileBloc.fetchProfile();

    return new Scaffold(
        appBar: AppBar(
            title: StreamBuilder<Profile>(
                stream: _profileBloc.profile,
                builder: (context, snapshot) {
                  if (snapshot == null || snapshot.data == null) {
                    return new Text("");
                  } else {
                    return new Text(
                        "${snapshot.data.firstName} ${snapshot.data.lastName}",
                        style: Theme.of(context).textTheme.headline);
                  }
                }),
            actions: _buildAppBarActions()),
        body: new Center(
          child: StreamBuilder(
              stream: _profileBloc.profile,
              builder: (context, AsyncSnapshot<Profile> snapshot) {
                if (snapshot.hasData) {
                  return _buildProfileScreen(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }

  SingleChildScrollView _buildProfileScreen(Profile data) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: <Widget>[
            _buildImageHeader(data),
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
                          new Text(data.job.toUpperCase(),
                              style: Theme.of(context).textTheme.title)
                        ]),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    _buildLocationRow(data),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    new Text(
                        AppLocalizations.of(context).translate('me_profile'),
                        style: Theme.of(context).textTheme.title),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    new Text(data.description),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    new Text(
                        AppLocalizations.of(context).translate('me_skills'),
                        style: Theme.of(context).textTheme.title),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    _buildSkillsChips(data),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    new Text(
                        AppLocalizations.of(context).translate('me_hobbies'),
                        style: Theme.of(context).textTheme.title),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    _buildHobbiesChips(data),
                  ]),
            ),
          ],
        ));
  }

  Container _buildImageHeader(Profile data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: new BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.fill,
              image: new NetworkImage(data.backgroundImageUrl))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                width: 110.0,
                height: 110.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(data.imageUrl)))),
          ]),
    );
  }

  Widget _buildLocationRow(Profile data) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(Icons.location_on, color: Theme.of(context).iconTheme.color),
        new Text(data.location),
      ],
    );
  }

  Widget _buildSkillsChips(Profile data) {
    if (data != null || data.distinctSkills != null) {
      return WidgetHelper.buildChips(
          context, data.distinctSkills.map((sk) => sk.name).toList());
    } else {
      return null;
    }
  }

  Widget _buildHobbiesChips(Profile data) {
    if (data != null || data.hobbies != null) {
      return WidgetHelper.buildChips(
          context, data.hobbies.map((hob) => hob.name).toList());
    } else {
      return null;
    }
  }

  List<Widget> _buildAppBarActions() {
    List<Widget> appBarActions = new List<Widget>();

    var isDarkModeOn = Provider.of<AppStateNotifier>(context).isDarkModeOn;

    var moreButtons = new PopupMenuButton(
      onSelected: (idx) {
        if (idx == 2) {
          this._onThemeChanged(isDarkModeOn);
        }
      },
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<int>>();
        list.add(
          CheckedPopupMenuItem(
            child: new Text(
                AppLocalizations.of(context)
                    .translate('app_settings_mode_dark'),
                style: Theme.of(context).textTheme.body1),
            value: 2,
            checked: isDarkModeOn,
          ),
        );
        return list;
      },
      icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
    );

    appBarActions.add(moreButtons);
    return appBarActions;
  }

  void _onThemeChanged(bool isDarkModeOn) {
    Provider.of<AppStateNotifier>(context).updateTheme(!isDarkModeOn);
  }
}
