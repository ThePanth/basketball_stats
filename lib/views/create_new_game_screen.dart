import 'package:basketball_stats/models/game_model.dart';
import 'package:basketball_stats/models/player_model.dart';
import 'package:basketball_stats/models/team_model.dart';
import 'package:basketball_stats/repositories/game_repository.dart';
import 'package:basketball_stats/repositories/player_repository.dart';
import 'package:basketball_stats/repositories/team_repository.dart';
import 'package:basketball_stats/ui/player_multi_select_dialog.dart';
import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateNewGameScreen extends StatefulWidget {
  @override
  _CreateNewGameScreenState createState() => _CreateNewGameScreenState();
}

class _CreateNewGameScreenState extends State<CreateNewGameScreen> {
  List<PlayerModel> _availablePlayers = []; // List of players to choose from
  List<PlayerModel> _firstTeamPlayers = [];
  List<PlayerModel> _secondTeamPlayers = [];

  final TextEditingController _firstTeamNameController = TextEditingController(
    text: tr("Team 1"),
  );
  final TextEditingController _secondTeamNameController = TextEditingController(
    text: tr("Team 2"),
  );

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  _loadPlayers() async {
    final players = await PlayerRepository.getAllPlayers();
    setState(() {
      _availablePlayers = players;
    });
  }

  void _selectPlayersForTeam(bool isFirstTeam) async {
    List<PlayerModel> selectedPlayers = await showDialog(
      context: context,
      builder:
          (context) => PlayerMultiSelectDialog(
            availablePlayers: _availablePlayers,
            selectedPlayers:
                isFirstTeam ? _firstTeamPlayers : _secondTeamPlayers,
          ),
    );

    setState(() {
      if (isFirstTeam) {
        _firstTeamPlayers = selectedPlayers;
      } else {
        _secondTeamPlayers = selectedPlayers;
      }
    });
  }

  bool _isPlayerInBothTeams(PlayerModel player) {
    return _firstTeamPlayers.contains(player) &&
        _secondTeamPlayers.contains(player);
  }

  void _createGame() async {
    if (_firstTeamPlayers.isEmpty) {
      _showError(tr("First team must be non empty"));
      return;
    }
    if (_secondTeamPlayers.isEmpty) {
      _showError("Second team must be non empty");
      return;
    }
    final playersInBothTeams =
        _firstTeamPlayers
            .where((ftp) => _secondTeamPlayers.any((stp) => ftp.id == stp.id))
            .toList();
    if (playersInBothTeams.isNotEmpty) {
      _showError(
        tr(
          "players_in_both_teams",
          args: [playersInBothTeams.map((p) => p.firstName).join(", ")],
        ),
      );
      return;
    }

    // Create game logic here
    final firstTeam = new TeamModel(
      id: Uuid().v4(),
      name: _firstTeamNameController.text,
      playerIds: _firstTeamPlayers.map((p) => p.id).toList(),
    );

    final secondTeam = new TeamModel(
      id: Uuid().v4(),
      name: _secondTeamNameController.text,
      playerIds: _secondTeamPlayers.map((p) => p.id).toList(),
    );

    await TeamRepository.addOrUpdateTeam(firstTeam);
    await TeamRepository.addOrUpdateTeam(secondTeam);

    final game = new GameModel(
      id: Uuid().v4(),
      startTime: DateTime.now(),
      firstTeamId: firstTeam.id,
      secondTeamId: secondTeam.id,
    );

    await GameRepository.addOrUpdateGame(game);

    Navigator.pop(context); // Go back after creating game
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr("Create New Game", context: context))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTeamBox(_firstTeamNameController, _firstTeamPlayers, true),
            SizedBox(height: 20),
            _buildTeamBox(_secondTeamNameController, _secondTeamPlayers, false),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _createGame,
              child: Text(tr("Start Game")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamBox(
    TextEditingController controller,
    List<PlayerModel> teamPlayers,
    bool isFirstTeam,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: tr("Team Name"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children:
                  teamPlayers.map((player) {
                    bool isDuplicate = _isPlayerInBothTeams(player);
                    return Chip(
                      label: Text("${player.firstName} ${player.lastName}"),
                      backgroundColor:
                          isDuplicate ? Colors.red[300] : Colors.blue[300],
                    );
                  }).toList(),
            ),
            TextButton(
              onPressed: () => _selectPlayersForTeam(isFirstTeam),
              child: Text(tr("Select Players")),
            ),
          ],
        ),
      ),
    );
  }
}
