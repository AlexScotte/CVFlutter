import 'package:cvflutter/notifiers/AppStateNotifier.dart';
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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Switch(
          value: Provider.of<AppStateNotifier>(context).isDarkMode,
          onChanged: (boolVal) {
            Provider.of<AppStateNotifier>(context).updateTheme(boolVal);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedIndex,
        onTap: onNavigationBarItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 0
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work,
                color: _selectedIndex == 1
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school,
                color: _selectedIndex == 2
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email,
                color: _selectedIndex == 3
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
    setState(() {
      _selectedIndex = newIndex;
    });
  }
}
