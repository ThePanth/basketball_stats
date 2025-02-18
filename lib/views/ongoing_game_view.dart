import 'dart:async';

import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/entities/player.dart';
import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/entities/team.dart';
import 'package:basketball_stats/models/statistic_type.dart';
import 'package:basketball_stats/services/game_service.dart';
import 'package:basketball_stats/ui/floating_button.dart';
import 'package:basketball_stats/ui/game_timer.dart';
import 'package:flutter/material.dart';

class OngoingGameView extends StatefulWidget {
  @override
  _OngoingGameViewState createState() => _OngoingGameViewState();
}

enum _StatisticButtonType { left, center, right }

class _OngoingGameViewState extends State<OngoingGameView> {
  late Timer _timer;

  final _floatingButtonKey = new GlobalKey<FloatingButtonState>();
  late FloatingButton _floatingButton;

  final Color _paleGreen = Color.fromARGB(255, 95, 170, 98);
  final Color _paleRed = Color.fromARGB(255, 173, 91, 91);
  final Color _paleBlue = Color.fromARGB(255, 91, 81, 179);
  final Color _paleYellow = Color.fromARGB(255, 185, 171, 44);
  Game? _ongoingGame;
  @override
  void initState() {
    super.initState();
    _floatingButton = FloatingButton(key: _floatingButtonKey);
    _loadOngoingGame();
  }

  _loadOngoingGame() async {
    final game = await GameService.getOngoingGame();

    setState(() {
      _ongoingGame = game;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ongoingGame == null) {
      if (_ongoingGame == null) {
        return _noOngoingGameView(context);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_ongoingGame!.getFirstTeamTotalStatistic().getTotalPoints()} - ${_ongoingGame!.getSecondTeamTotalStatistic().getTotalPoints()}",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              GameTimer(startTime: _ongoingGame!.startTime),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _teamSection(_ongoingGame!.firstTeam),
                _teamSection(_ongoingGame!.secondTeam),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _finishGameConfirm,
            child: Text("Finish game"),
          ),
        ],
      ),
      floatingActionButton: _floatingButton,
    );
  }

  // View to show when no ongoing game exists
  Widget _noOngoingGameView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No ongoing game",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _createNewGame,
            child: Text("Create New Game"),
          ),
        ],
      ),
    );
  }

  Widget _teamSection(Team team) {
    return Expanded(
      child: Column(
        children: [
          Text(
            team.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView(
              children:
                  team.players
                      .map((player) => _buildPlayerCard(player))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(Team team) {
    // Fetch players from Hive or state management
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            team.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Column(
            children:
                team.players.map((player) => _buildPlayerCard(player)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text("${player.firstName} ${player.lastName}"),
        subtitle: Wrap(
          spacing: 4,
          children: [
            Row(
              children: [
                _buildNonCrossedTextButton(
                  "+2",
                  _paleGreen,
                  _StatisticButtonType.left,
                  () => _updateStat(player, StatisticsType.twoPointSuccess),
                ),
                _buildNonCrossedTextButton(
                  "+3",
                  _paleGreen,
                  _StatisticButtonType.center,
                  () => _updateStat(player, StatisticsType.threePointSuccess),
                ),
                _buildNonCrossedTextButton(
                  "A",
                  _paleYellow,
                  _StatisticButtonType.right,
                  () => _updateStat(player, StatisticsType.assist),
                ),
              ],
            ),
            Row(
              children: [
                _buildCrossedTextButton(
                  "+2",
                  _paleRed,
                  _StatisticButtonType.left,
                  () => _updateStat(player, StatisticsType.twoPointMiss),
                ),
                _buildCrossedTextButton(
                  "+3",
                  _paleRed,
                  _StatisticButtonType.center,
                  () => _updateStat(player, StatisticsType.threePointMiss),
                ),
                _buildNonCrossedTextButton(
                  "R",
                  _paleBlue,
                  _StatisticButtonType.right,
                  () => _updateStat(player, StatisticsType.rebound),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(icon: Icon(icon, color: color), onPressed: onPressed);
  }

  Widget _buildCrossedTextButton(
    String text,
    Color color,
    _StatisticButtonType buttonType,
    VoidCallback onPressed,
  ) {
    return _buildTextButton(
      text,
      color,
      buttonType,
      onPressed,
      TextDecoration.lineThrough,
    );
  }

  Widget _buildNonCrossedTextButton(
    String text,
    Color color,
    _StatisticButtonType buttonType,
    VoidCallback onPressed,
  ) {
    return _buildTextButton(
      text,
      color,
      buttonType,
      onPressed,
      TextDecoration.none,
    );
  }

  Widget _buildTextButton(
    String text,
    Color color,
    _StatisticButtonType buttonType,
    VoidCallback onPressed,
    TextDecoration decoration,
  ) {
    return Container(
      margin: switch (buttonType) {
        _StatisticButtonType.left => EdgeInsets.only(
          right: 3,
          left: 0,
          top: 3,
          bottom: 3,
        ),
        _StatisticButtonType.center => EdgeInsets.all(3),
        _StatisticButtonType.right => EdgeInsets.only(
          right: 0,
          left: 3,
          top: 3,
          bottom: 3,
        ),
      },
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(), // Makes the button circular
          padding: EdgeInsets.all(10), // Adjust padding for size
          minimumSize: Size(50, 50),
        ),
        child: Text.rich(
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
              decoration: decoration, // Crosses out the number
            ),
          ),
        ),
      ),
    );
  }

  void _updateStat(Player player, StatisticsType type) async {
    final newItem = _ongoingGame!.addStatisticItem(player.id, type);
    await GameService.addOrUpdateGame(_ongoingGame!);
    _loadOngoingGame();
    _floatingButtonKey.currentState?.addTemporaryButton(
      FloatingButtonData(
        text: "Undo ${type.getDisplayName()} from ${player.firstName}",
        action: () => _removeStat(newItem),
      ),
    );
  }

  void _removeStat(StatisticItem item) async {
    _ongoingGame!.removeStatisticItem(item);
    await GameService.addOrUpdateGame(_ongoingGame!);
    _loadOngoingGame();
  }

  void _finishGameConfirm() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Finish the game'),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            // Add Player Button
            ElevatedButton(
              onPressed: () {
                _finishGame();
                Navigator.pop(context);
              },
              child: Text('Finish'),
            ),
          ],
        );
      },
    );
  }

  void _finishGame() async {
    _ongoingGame!.endTime = DateTime.now();
    await GameService.addOrUpdateGame(_ongoingGame!);
    _loadOngoingGame();
  }

  void _createNewGame() async {
    // Navigate to the Game Creation screen
    await Navigator.pushNamed(context, '/create-game');
    _loadOngoingGame();
  }
}
