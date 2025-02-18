
import 'package:basketball_stats/entities/player.dart';
import 'package:basketball_stats/repositories/player_repository.dart';

class PlayerService {
  static Future<Player> getPlayer(String id) async {
    return Player.of(await PlayerRepository.getPlayer(id));
  }

  static Future<List<Player>> getPlayers(List<String> ids) async {
    return (await PlayerRepository.getPlayers(ids)).map((pm) => Player.of(pm)).toList();
  }

  static Future<void> save(Player p) async {
    await PlayerRepository.addOrUpdatePlayer(p.toModel());
  }

  static Future<List<Player>> getAllPlayers() async {
    return (await PlayerRepository.getAllPlayers()).map((pm) => Player.of(pm)).toList();
  }

  static Future<void> deletePlayer(String id) async {
    await PlayerRepository.deletePlayer(id);
  }
}