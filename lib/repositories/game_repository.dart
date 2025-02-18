import 'package:basketball_stats/models/game_model.dart';
import 'package:hive/hive.dart';

class GameRepository {
  static const _gameBoxName = 'games';

  // Get game box
  static Future<Box<GameModel>> _getGameBox() async {
    return await Hive.openBox<GameModel>(_gameBoxName);
  }

  // Create or update game
  static Future<void> addOrUpdateGame(GameModel game) async {
    final gameBox = await _getGameBox();
    await gameBox.put(game.id, game); // If id exists, it updates the game
  }

  // Get all games
  static Future<List<GameModel>> getAllGames() async {
    final gameBox = await _getGameBox();
    return gameBox.values.toList();
  }

  // Delete game
  static Future<void> deleteGame(String id) async {
    final gameBox = await _getGameBox();
    await gameBox.delete(id);
  }

  // Delete game
  static Future<GameModel?> getOngoingGame() async {
    final gameBox = await _getGameBox();
    final latestUnfinishedGame =
        await gameBox.values.where((g) => g.endTime == null).toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
    return latestUnfinishedGame.isNotEmpty ? latestUnfinishedGame.first : null;
  }

  static Future<List<GameModel>> getGames(List<String> ids) async {
    final gameBox = await _getGameBox();
    return gameBox.values.where((p) => ids.contains(p.id)).toList()
      ..sort((g1, g2) => g1.startTime.compareTo(g2.startTime));
  }

  static Future<GameModel> getGame(String id) async {
    return (await getGames([id])).first;
  }
}
