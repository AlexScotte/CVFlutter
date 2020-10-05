import 'package:cvflutter/notifiers/AppStateNotifier.dart';
import 'package:cvflutter/pages/navigation_pages/contact_page.dart';
import 'package:cvflutter/pages/navigation_pages/experiences_page.dart';
import 'package:cvflutter/pages/navigation_pages/formations_page.dart';
import 'package:cvflutter/pages/navigation_pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BottomNavigationBar bottomNavigationBar;

  int selectedIndex = 0;

  final List<Widget> navigationPages = [
    ProfilePage(),
    ExperiencePage(),
    FormationsPage(),
    ContactPage()
  ];

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: navigationPages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: selectedIndex,
        onTap: onNavigationBarItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: selectedIndex == 0
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work,
                color: selectedIndex == 1
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school,
                color: selectedIndex == 2
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email,
                color: selectedIndex == 3
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
        ],
      ),
    );
    return scaffold;
  }

  void onNavigationBarItemTapped(int newIndex) {
    // Make a setState to reload widget and:
    // - load the correct navigation page
    // - change color icon in bottom nav bar
    setState(() {
      selectedIndex = newIndex;
    });
  }
}
