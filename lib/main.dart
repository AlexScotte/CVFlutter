import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'notifiers/AppStateNotifier.dart';
import 'pages/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
        create: (context) => AppStateNotifier(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          locale: Locale('fr', 'FR'), // switch between en and ru to see effect
          // localizationsDelegates: [const DemoLocalizationsDelegate()],
          // List all of the app's supported locales here
          supportedLocales: [
            Locale('en', 'EN'),
            Locale('fr', 'FR'),
          ],
          // These delegates make sure that the localization data for the proper language is loaded
          localizationsDelegates: [
            // THIS CLASS WILL BE ADDED LATER
            // A class which loads the translations from JSON files
            AppLocalizations.delegate,
            // Built-in localization of basic text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          // Returns a locale which will be used by the app
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
          theme: ThemeData.light().copyWith(
              primaryColor: Colors.white,
              accentColor: Colors.blue[900],
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(
                  title: TextStyle(fontSize: 18, color: Colors.blue[900]),
                  headline: TextStyle(fontSize: 18, color: Colors.black),
                  body1: TextStyle(fontSize: 14, color: Colors.black),
                  body2: TextStyle(fontSize: 12, color: Colors.black))),

          darkTheme: ThemeData.dark().copyWith(
              accentColor: Colors.cyanAccent[400],
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(
                title: TextStyle(fontSize: 18, color: Colors.cyanAccent[400]),
                headline: TextStyle(fontSize: 18, color: Colors.white),
                body1: TextStyle(fontSize: 14, color: Colors.white),
                body2: TextStyle(fontSize: 12, color: Colors.white),
              )),
          themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          home: MyHomePage(),
        );
      },
    );
  }
}
