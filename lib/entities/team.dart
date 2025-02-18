
import 'package:basketball_stats/entities/player.dart';
import 'package:basketball_stats/models/team_model.dart';

class Team {
  String id;
  String name;
  List<Player> players;
  
  Team({required this.id, required this.name, required this.players });

  static Team of(TeamModel m, List<Player> players) {
    final teamPlayers = players.where((p) => m.playerIds.contains(p.id)).toList();
    return Team(id: m.id, name: m.name, players: teamPlayers);
  }

  TeamModel toModel() {
    return TeamModel(id: id, name: name, playerIds: players.map((p) => p.id).toList());
  }
}