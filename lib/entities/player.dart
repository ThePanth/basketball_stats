import 'package:basketball_stats/models/player_model.dart';

class Player {
  String id;
  String firstName;
  String lastName;
  final int badgeColor;  // Add this field

  Player({required this.id, required this.firstName, required this.lastName, required this.badgeColor});
  static Player of(PlayerModel m) {
    return Player(id: m.id, firstName: m.firstName, lastName: m.lastName, badgeColor: m.badgeColor);
  }

  PlayerModel toModel() {
    return PlayerModel(id: id, firstName: firstName, lastName: lastName, badgeColor: badgeColor);
  }
}