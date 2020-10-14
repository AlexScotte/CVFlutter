import 'package:cvflutter/bloc/profile_bloc.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../app_localizations.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc profileBloc = new ProfileBloc();

  @override
  Widget build(BuildContext context) {
    profileBloc.fetchProfile();

    return new Scaffold(
        appBar: AppBar(
            title: StreamBuilder<Profile>(
                stream: profileBloc.profile,
                builder: (context, snapshot) {
                  return new Text(
                      "${snapshot.data.firstName} ${snapshot.data.lastName}");
                })),
        body: new Center(
          child: StreamBuilder(
              stream: profileBloc.profile,
              builder: (context, AsyncSnapshot<Profile> snapshot) {
                if (snapshot.hasData) {
                  return buildProfileScreen(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }

  Container buildProfileScreen(Profile data) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildImageHeader(data),
            new Text(data.job),
            new Text(data.location),
            new Text(AppLocalizations.of(context).translate('me_profile')),
            new Text(data.description),
            new Text(AppLocalizations.of(context).translate('me_skills')),
            new Text(AppLocalizations.of(context).translate('me_hobbies')),
          ]),
    );
  }

  Container buildImageHeader(Profile data) {
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
}
