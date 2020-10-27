import 'package:cvflutter/bloc/profile_bloc.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/widgets/horizontal_alignment.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildImageHeader(data),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[new Text(data.job)]),
            buildLocationRow(data),
            new Text(AppLocalizations.of(context).translate('me_profile'),
                style: Theme.of(context).textTheme.title),
            new Text(data.description),
            new Text(AppLocalizations.of(context).translate('me_skills'),
                style: Theme.of(context).textTheme.title),
            new Text(AppLocalizations.of(context).translate('me_hobbies'),
                style: Theme.of(context).textTheme.title),
            buildChips(data),
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

  Widget buildLocationRow(Profile data) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(Icons.location_on, color: Theme.of(context).iconTheme.color),
        new Text(data.location),
      ],
    );
  }

  Widget buildChips(Profile data) {
    List<Widget> chips = new List<Widget>();

    if (data != null || data.hobbies != null) {
      for (int i = 0; i < data.hobbies.length; i++) {
        var hobby = data.hobbies[i];
        ChoiceChip choiceChip = ChoiceChip(
          selected: false,
          label: Text(hobby.name),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.black54,
        );

        chips.add(choiceChip);
      }
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
