import 'package:cvflutter/pages/navigation_pages/contact_page.dart';
import 'package:cvflutter/pages/navigation_pages/experiences_page.dart';
import 'package:cvflutter/pages/navigation_pages/formations_page.dart';
import 'package:cvflutter/pages/navigation_pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BottomNavigationBar bottomNavigationBar;

  int _selectedIndex = 0;

  final List<Widget> _navigationPages = [
    ProfilePage(),
    ExperiencePage(),
    FormationsPage(),
    ContactPage()
  ];

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: _navigationPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedIndex,
        onTap: _onNavigationBarItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 0
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title:
                Text(AppLocalizations.of(context).translate('title_profile')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work,
                color: _selectedIndex == 1
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(
                AppLocalizations.of(context).translate('title_experiences')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school,
                color: _selectedIndex == 2
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title:
                Text(AppLocalizations.of(context).translate('title_formation')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email,
                color: _selectedIndex == 3
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title:
                Text(AppLocalizations.of(context).translate('title_contact')),
          ),
        ],
      ),
    );
    return scaffold;
  }

  void _onNavigationBarItemTapped(int newIndex) {
    // Make a setState to reload widget and:
    // - load the correct navigation page
    // - change color icon in bottom nav bar
    setState(() {
      _selectedIndex = newIndex;
    });
  }
}
