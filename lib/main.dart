import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifiers/AppStateNotifier.dart';
import 'pages/homepage/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
            accentColor: Colors.blue[900],
            iconTheme: IconThemeData(color: Colors.black),
          ),
          darkTheme: ThemeData.dark().copyWith(
            accentColor: Colors.cyanAccent[400],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}
