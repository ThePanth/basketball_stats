import 'package:flutter/material.dart';
import '../models/player_model.dart';

class PlayerMultiSelectDialog extends StatefulWidget {
  final List<PlayerModel> availablePlayers;
  final List<PlayerModel> selectedPlayers;

  PlayerMultiSelectDialog({
    required this.availablePlayers,
    required this.selectedPlayers,
  });

  @override
  _PlayerMultiSelectDialogState createState() =>
      _PlayerMultiSelectDialogState();
}

class _PlayerMultiSelectDialogState extends State<PlayerMultiSelectDialog> {
  late List<PlayerModel> _tempSelectedPlayers;

  @override
  void initState() {
    super.initState();
    _tempSelectedPlayers = List.from(widget.selectedPlayers);
  }

  void _onPlayerTapped(PlayerModel player) {
    setState(() {
      if (_tempSelectedPlayers.contains(player)) {
        _tempSelectedPlayers.remove(player);
      } else if (_tempSelectedPlayers.length < 5) {
        _tempSelectedPlayers.add(player);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Players (4-5)"),
      content: SingleChildScrollView(
        child: Column(
          children:
              widget.availablePlayers.map((player) {
                bool isSelected = _tempSelectedPlayers.contains(player);
                return ListTile(
                  title: Text("${player.firstName} ${player.lastName}"),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          _onPlayerTapped(player);
                        },
                      ),
                      CircleAvatar(backgroundColor: Color(player.badgeColor)),
                    ],
                  ),
                  onTap: () => _onPlayerTapped(player),
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              () => Navigator.pop(context, widget.selectedPlayers), // Cancel
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_tempSelectedPlayers.length >= 4 &&
                _tempSelectedPlayers.length <= 5) {
              Navigator.pop(context, _tempSelectedPlayers);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please select 4-5 players.")),
              );
            }
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
