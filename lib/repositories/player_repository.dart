import 'package:basketball_stats/models/player_model.dart';
import 'package:hive/hive.dart';

class PlayerRepository {
  static const _playerBoxName = 'players';

  // Get player box
  static Future<Box<PlayerModel>> _getPlayerBox() async {
    return await Hive.openBox<PlayerModel>(_playerBoxName);
  }

  // Create or update player
  static Future<void> addOrUpdatePlayer(PlayerModel player) async {
    final playerBox = await _getPlayerBox();
    await playerBox.put(player.id, player);  // If id exists, it updates the player
  }

  // Get all players
  static Future<List<PlayerModel>> getAllPlayers() async {
    final playerBox = await _getPlayerBox();
    return playerBox.values.toList()..sort((p1, p2) => p1.firstName.compareTo(p2.firstName));
  }

  // Delete player
  static Future<void> deletePlayer(String id) async {
    final playerBox = await _getPlayerBox();
    await playerBox.delete(id);
  }

  // Get players by Id
  static Future<List<PlayerModel>> getPlayers(List<String> ids) async {
    final playerBox = await _getPlayerBox();
    return playerBox.values.where((p) => ids.contains(p.id)).toList()..sort((p1, p2) => p1.firstName.compareTo(p2.firstName));
  }

  static Future<PlayerModel> getPlayer(String id) async {
    return (await getPlayers([id])).first;
  }
}
