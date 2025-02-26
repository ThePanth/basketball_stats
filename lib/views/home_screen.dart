import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:basketball_stats/views/game_history_view.dart';
import 'package:basketball_stats/views/ongoing_game_view.dart';
import 'package:basketball_stats/views/players_view.dart';
import 'package:basketball_stats/views/statistics_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of Views
  final List<Widget> _screens = [
    OngoingGameView(
      key: PageStorageKey('OngoingGameView'),
    ), // Current game tracking
    GameHistoryView(key: PageStorageKey('GameHistoryView')), // Game history
    PlayersView(key: PageStorageKey('PlayersView')), // Player management
    StatisticsView(key: PageStorageKey('StatisticsView')), // Overall statistics
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ), // Show the selected view
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.orangeAccent, // Highlighted tab color
        unselectedItemColor:
            Colors.blueGrey[900], // Faded color for inactive tabs
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: tr('Game', context: context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: tr('History', context: context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: tr('Players', context: context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: tr('Stats', context: context),
          ),
        ],
      ),
    );
  }
}
