import 'package:cvflutter/bloc/profile_bloc.dart';
import 'package:cvflutter/helpers/widget_helper.dart';
import 'package:cvflutter/managers/preferences_manager.dart';
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
  ProfileBloc _profileBloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    _profileBloc.fetchProfile(context);

    return Scaffold(
        appBar: AppBar(
            title: StreamBuilder<Profile>(
                stream: _profileBloc.profile,
                builder: (context, snapshot) {
                  if (snapshot == null || snapshot.data == null) {
                    return Text("");
                  } else {
                    return Text(
                        "${snapshot.data.firstName} ${snapshot.data.lastName}",
                        style: Theme.of(context).textTheme.headline2);
                  }
                }),
            actions: _buildAppBarActions()),
        body: Center(
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
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(data.job.toUpperCase(),
                              style: Theme.of(context).textTheme.caption)
                        ]),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    _buildLocationRow(data),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    Text(AppLocalizations.of(context).translate('me_profile'),
                        style: Theme.of(context).textTheme.caption),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Text(data.description),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    Text(AppLocalizations.of(context).translate('me_skills'),
                        style: Theme.of(context).textTheme.caption),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    _buildSkillsChips(data),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(AppLocalizations.of(context).translate('me_hobbies'),
                        style: Theme.of(context).textTheme.caption),
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
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill, image: NetworkImage(data.backgroundImageUrl))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 110.0,
                height: 110.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(data.imageUrl)))),
          ]),
    );
  }

  Widget _buildLocationRow(Profile data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.location_on, color: Theme.of(context).iconTheme.color),
        Text(data.location),
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
    List<Widget> appBarActions = List<Widget>();

    var isDarkModeOn = PreferenceManager().isDarkThemeOn();

    var moreButtons = PopupMenuButton(
      onSelected: (idx) {
        if (idx == 2) {
          this._onThemeChanged(isDarkModeOn);
        }
      },
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<int>>();
        list.add(
          CheckedPopupMenuItem(
            child: Text(
                AppLocalizations.of(context)
                    .translate('app_settings_mode_dark'),
                style: Theme.of(context).textTheme.bodyText1),
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
