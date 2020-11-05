import 'package:cvflutter/bloc/contact_bloc.dart';
import 'package:cvflutter/model/contact.dart';
import 'package:cvflutter/model/external_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactBloc _contactBloc = new ContactBloc();
  @override
  Widget build(BuildContext context) {
    _contactBloc.fetchContact();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            AppLocalizations.of(context).translate('title_view_contact'),
            style: Theme.of(context).textTheme.headline),
      ),
      body: new StreamBuilder(
          stream: _contactBloc.contact,
          builder: (context, AsyncSnapshot<Contact> snapshot) {
            if (snapshot.hasData) {
              return _buildBody(snapshot.data);
            } else if (snapshot.hasError) {
              return new Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildBody(Contact contact) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var leftPadding = w > h ? w * 0.35 : w * 0.10;
    var topPadding = w > h ? 5.0 : 30.0;
    return Column(children: <Widget>[
      new Expanded(
          child: new Container(
        padding: EdgeInsets.only(left: leftPadding, top: topPadding),
        child: _buildListExternalLinks(contact),
      )),
      new RaisedButton(
        child: new Text(
            AppLocalizations.of(context).translate('contact_download'),
            style: new TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () async {
          if (await canLaunch(contact.cvUrl)) await launch(contact.cvUrl);
        },
        color: Theme.of(context).accentColor,
      ),
    ]);
  }

  Widget _buildListExternalLinks(Contact contact) {
    if (contact.externalLinks == null || contact.externalLinks.isEmpty)
      return new Text("");

    var items = new List<Widget>();
    if (contact.phone != null && contact.phone.trim().isNotEmpty) {
      items.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Icon(
              Icons.phone,
              color: Theme.of(context).iconTheme.color,
              size: 30,
            ),
            new Padding(padding: EdgeInsets.only(left: 10.0)),
            new Text(contact.phone,
                style: Theme.of(context).textTheme.headline),
          ],
        ),
      );
      items.add(Padding(padding: EdgeInsets.only(top: 20.0)));
    }

    if (contact.email != null && contact.email.trim().isNotEmpty) {
      items.add(new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Icon(
            Icons.email,
            color: Theme.of(context).iconTheme.color,
            size: 30,
          ),
          new Padding(padding: EdgeInsets.only(left: 10.0)),
          new Text(contact.email, style: Theme.of(context).textTheme.headline),
        ],
      ));
      items.add(Padding(padding: EdgeInsets.only(top: 20.0)));
    }

    for (var extLink in contact.externalLinks) {
      items.add(_buildItem(extLink));
      items.add(Padding(padding: EdgeInsets.only(top: 20.0)));
    }

    return ListView(shrinkWrap: true, children: items);
  }

  Widget _buildItem(ExternalLink extLink) {
    String linkName = extLink.url
        .toLowerCase()
        .replaceAll("https://", "")
        .replaceAll("http://", "")
        .replaceAll("www.", "");

    return Center(
        child: Row(
      children: <Widget>[
        new Container(
            width: 30.0,
            height: 30.0,
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: new NetworkImage(extLink.imageUrl)))),
        new Padding(padding: EdgeInsets.only(left: 10.0)),
        new Flexible(
          child: InkWell(
            onTap: () async {
              if (await canLaunch(extLink.url)) await launch(extLink.url);
            },
            child:
                new Text(linkName, style: Theme.of(context).textTheme.headline),
          ),
        )
      ],
    ));
  }
}
