import 'dart:math';

import 'package:basketball_stats/models/player_model.dart';
import 'package:basketball_stats/repositories/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

class PlayersView extends StatefulWidget {
  @override
  _PlayersViewState createState() => _PlayersViewState();
}

class _PlayersViewState extends State<PlayersView> {
  List<PlayerModel> _players = [];
  Color _selectedColor = Colors.white;  // Default color
  final TextEditingController _firstNameEditingController = new TextEditingController();
  final TextEditingController _lastNameEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  _loadPlayers() async {
    final players = await PlayerRepository.getAllPlayers();
    setState(() {
      _players = players;
    });
  }

  _addPlayer() {
    final player = PlayerModel(
      id: Uuid().v4(),
      firstName: _firstNameEditingController.text,
      lastName: _lastNameEditingController.text,
      badgeColor: _selectedColor.toARGB32(),
    );
    PlayerRepository.addOrUpdatePlayer(player);
    _loadPlayers();
  }

  _updatePlayer(String id) {
    final player = PlayerModel(
      id: id,
      firstName: _firstNameEditingController.text,
      lastName: _lastNameEditingController.text,
      badgeColor: _selectedColor.toARGB32(),
    );
    PlayerRepository.addOrUpdatePlayer(player);
    _loadPlayers();
  }

  _openAddPlayerDialog() {
    _firstNameEditingController.clear();
    _lastNameEditingController.clear();
    _selectedColor = getRandomColor();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Player'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _firstNameEditingController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextField(
                controller: _lastNameEditingController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(height: 16),
              // Color Picker (for now, just a simple dropdown)
              ColorPicker(
                pickerColor: _selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ],
          ),
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
                if (_firstNameEditingController.text.isNotEmpty) {
                  _addPlayer();
                  Navigator.pop(context);
                }
              },
              child: Text('Add Player'),
            ),
          ],
        );
      },
    );
  }

  _openEditPlayerDialog(PlayerModel player) {
    _firstNameEditingController.text = player.firstName;
    _lastNameEditingController.text = player.lastName;
    _selectedColor = Color(player.badgeColor);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Player'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _firstNameEditingController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextField(
                controller: _lastNameEditingController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(height: 16),
              // Color Picker (for now, just a simple dropdown)
              ColorPicker(
                pickerColor: Color(player.badgeColor),
                onColorChanged: (Color color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ],
          ),
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
                if (_firstNameEditingController.text.isNotEmpty) {
                  _updatePlayer(player.id);
                  Navigator.pop(context);
                }
              },
              child: Text('Update Player'),
            ),
          ],
        );
      },
    );
  }
  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),  // Red: 0-255
      random.nextInt(256),  // Green: 0-255
      random.nextInt(256),  // Blue: 0-255
      1,  // Alpha: 1 (fully opaque)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player Management')),
      body: ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final player = _players[index];
          return ListTile(
            title: Text("${player.firstName} ${player.lastName}"),
            leading: CircleAvatar(
              backgroundColor: Color(player.badgeColor)
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _openEditPlayerDialog(player)
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePlayer(player.id)
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddPlayerDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  _deletePlayer(String id) {
    PlayerRepository.deletePlayer(id);
    _loadPlayers();
  }
}
