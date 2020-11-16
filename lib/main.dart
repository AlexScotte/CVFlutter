import 'package:cvflutter/managers/data_manager.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/managers/preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'notifiers/AppStateNotifier.dart';
import 'pages/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager().init();
  await LocalDatabaseManager().init();
  await DataManager().init();
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
          locale: Locale('fr', 'FR'),
          supportedLocales: [
            Locale('en', 'EN'),
            Locale('fr', 'FR'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          theme: ThemeData.light().copyWith(
              primaryColor: Colors.white,
              accentColor: Colors.blue[900],
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(
                caption: TextStyle(
                  fontSize: 18,
                  color: Colors.blue[900],
                ),
                subtitle1: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
                headline2: TextStyle(fontSize: 18, color: Colors.black),
                bodyText1: TextStyle(fontSize: 14, color: Colors.black),
                bodyText2: TextStyle(fontSize: 12, color: Colors.black),
              )),
          darkTheme: ThemeData.dark().copyWith(
              accentColor: Colors.cyanAccent[400],
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(
                caption: TextStyle(fontSize: 18, color: Colors.cyanAccent[400]),
                subtitle1: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
                headline2: TextStyle(fontSize: 18, color: Colors.white),
                bodyText1: TextStyle(fontSize: 14, color: Colors.white),
                bodyText2: TextStyle(fontSize: 12, color: Colors.white),
              )),
          themeMode: PreferenceManager().isDarkThemeOn()
              ? ThemeMode.dark
              : ThemeMode.light,
          home: MyHomePage(),
        );
      },
    );
  }
}
