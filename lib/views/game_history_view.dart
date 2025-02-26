import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/services/game_service.dart';
import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:basketball_stats/utils/game_notifier.dart';
import 'package:basketball_stats/views/game_statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameHistoryView extends StatefulWidget {
  const GameHistoryView({Key? key}) : super(key: key);
  @override
  _GameHistoryViewState createState() => _GameHistoryViewState();
}

class _GameHistoryViewState extends State<GameHistoryView>
    with WidgetsBindingObserver {
  List<Game> _games = [];
  @override
  void initState() {
    super.initState();
    eventBus.changeEvents.listen(_gameChanged);
    eventBus.createEvents.listen(_gameCreated);
    eventBus.deleteEvents.listen(_gameDeleted);
    WidgetsBinding.instance.addObserver(this);
    _loadGames();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  _gameChanged(changedGameId) {
    GameService.getGame(changedGameId).then((game) {
      setState(() {
        _games.removeWhere((g) => g.id == changedGameId);
        _games
          ..add(game)
          ..sort((g1, g2) => g1.startTime.compareTo(g2.startTime));
      });
    });
  }

  _gameCreated(createdGameId) {
    GameService.getGame(createdGameId).then((game) {
      setState(() {
        _games
          ..add(game)
          ..sort((g1, g2) => g1.startTime.compareTo(g2.startTime));
      });
    });
  }

  _gameDeleted(deletedGameId) {
    setState(() {
      _games.removeWhere((g) => g.id == deletedGameId);
    });
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
      appBar: AppBar(title: Text(tr('Games History'))),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return Row(
            children: [
              // Date
              Text(
                DateFormat(
                  'd MMMM yyyy HH:mm',
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
              IconButton(
                icon: Icon(Icons.delete, size: 28, color: Colors.blue),
                onPressed: () => _deleteGameConfirmation(game),
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

  void _deleteGameConfirmation(Game g) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${tr('Delete the game for')} ${DateFormat('d MMMM yyyy HH:mm').format(g.startTime)}?',
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(tr('Cancel')),
            ),
            // Add Player Button
            ElevatedButton(
              onPressed: () {
                _deleteGame(g);
                Navigator.pop(context);
              },
              child: Text(tr('Delete')),
            ),
          ],
        );
      },
    );
  }

  void _deleteGame(Game g) {
    GameService.deleteGame(g.id);
    setState(() {
      _games.removeWhere((game) => g.id == game.id);
    });
  }
}
