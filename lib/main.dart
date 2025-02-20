import 'package:basketball_stats/repositories/setup_adapters.dart';
import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:basketball_stats/views/create_new_game_screen.dart';
import 'package:basketball_stats/views/game_statistics_screen.dart';
import 'package:basketball_stats/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  await Hive.initFlutter();

  registerAddapters();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('uk', ''); // Default language

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Stats',
      supportedLocales: [
        Locale('en', ''), // English
        Locale('uk', ''), // Ukrainian
      ],
      locale: _locale, // Use the selected locale
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first; // Default to English
      },
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/create-game': (context) => CreateNewGameScreen(),
      },
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
