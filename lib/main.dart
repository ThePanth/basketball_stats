import 'package:basketball_stats/repositories/setup_adapters.dart';
import 'package:basketball_stats/views/create_new_game_screen.dart';
import 'package:basketball_stats/views/game_statistics_screen.dart';
import 'package:basketball_stats/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  registerAddapters();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Stats',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(
      //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/create-game': (context) => CreateNewGameScreen(),
      },
    );
  }
}
