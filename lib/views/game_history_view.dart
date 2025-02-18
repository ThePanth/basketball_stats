import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/services/game_service.dart';
import 'package:basketball_stats/views/game_statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameHistoryView extends StatefulWidget {
  @override
  _GameHistoryViewState createState() => _GameHistoryViewState();
}

class _GameHistoryViewState extends State<GameHistoryView> {
  List<Game> _games = [];
  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  _loadGames() async {
    final games =
        await GameService.getAllGames()
          ..sort((g1, g2) => g1.startTime.compareTo(g2.startTime));
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Games History')),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return Row(
            children: [
              // Date
              Text(
                DateFormat(
                  'd MMMM yyyy',
                ).format(game.startTime), // "4 February 2025"
                style: TextStyle(fontSize: 16),
              ),

              // Spacer to push score to the right
              Spacer(),

              // Score
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  '${game.getFirstTeamTotalStatistic().getTotalPoints()}:${game.getSecondTeamTotalStatistic().getTotalPoints()}', // "41:39"
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, size: 28, color: Colors.blue),
                onPressed: () => _lookGameStatistics(game),
              ),
            ],
          );
        },
      ),
    );
  }

  void _lookGameStatistics(Game g) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameStatisticsScreen(gameId: g.id),
      ),
    );
  }
}
