import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/models/statistic_type.dart';
import 'package:basketball_stats/services/game_service.dart';
import 'package:basketball_stats/ui/games_statistics_list.dart';
import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:basketball_stats/utils/game_notifier.dart';
import 'package:flutter/material.dart';

class GameStatisticsScreen extends StatefulWidget {
  final String gameId;
  const GameStatisticsScreen({required this.gameId, Key? key})
    : super(key: key);

  @override
  _GameStatisticsScreenState createState() => _GameStatisticsScreenState();
}

class _GameStatisticsScreenState extends State<GameStatisticsScreen>
    with WidgetsBindingObserver {
  late Map<String, List<PlayerStat>> _statistics;
  late Game _game;
  @override
  void initState() {
    super.initState();
    eventBus.changeEvents.listen(_gameChanged);
    eventBus.deleteEvents.listen(_gameDeleted);
    WidgetsBinding.instance.addObserver(this);
    _loadGame();
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
    if (changedGameId == _game.id) {
      _loadGame();
    }
  }

  _gameDeleted(deletedGameId) {
    if (deletedGameId == _game.id) {
      Navigator.pop(context);
    }
  }

  _loadGame() async {
    final game = await GameService.getGame(widget.gameId);
    final firstTeamStatistics =
        game.firstTeam.players
            .map(
              (p) => PlayerStat.of(
                game.playerStatistics[p.id]!,
                p.firstName,
                game.firstTeam.name,
              ),
            )
            .toList()
          ..sort((a, b) => a.playerName.compareTo(b.playerName));
    final secondTeamStatistics =
        game.secondTeam.players
            .map(
              (p) => PlayerStat.of(
                game.playerStatistics[p.id]!,
                p.firstName,
                game.firstTeam.name,
              ),
            )
            .toList()
          ..sort((a, b) => a.playerName.compareTo(b.playerName));

    final statistics =
        (firstTeamStatistics + secondTeamStatistics)
          ..sort((a, b) => a.playerName.compareTo(b.playerName));

    setState(() {
      _game = game;
      _statistics = {
        tr("All teams"): statistics,
        game.firstTeam.name: firstTeamStatistics,
        game.secondTeam.name: secondTeamStatistics,
      };
    });
  }

  // Example data (Replace with real data)

  @override
  Widget build(BuildContext context) {
    final dropDownItems = [
      tr("All teams"),
      _game.firstTeam.name,
      _game.secondTeam.name,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(tr("Game Statistics"))),
      body: GamesStatisticsList(gameStatistics: _statistics),
    );
  }
}
