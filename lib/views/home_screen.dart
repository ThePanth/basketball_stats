import 'package:basketball_stats/views/game_history_view.dart';
import 'package:basketball_stats/views/ongoing_game_view.dart';
import 'package:basketball_stats/views/players_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of Views
  final List<Widget> _screens = [
    OngoingGameView(),  // Current game tracking
    GameHistoryView(),      // Game history
    PlayersView(),      // Player management
    PlayersView(),   // Overall statistics
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // Show the selected view
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.orangeAccent, // Highlighted tab color
        unselectedItemColor: Colors.blueGrey[900],    // Faded color for inactive tabs
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
