import 'package:basketball_stats/models/player_game_statistic_model.dart';
import 'package:hive/hive.dart';

class PlayerGameStatisticRepository {
  static const _playerGameStatisticBoxName = 'playerGameStatistics';

  // Get playerGameStatistic box
  static Future<Box<PlayerGameStatisticModel>>
  _getPlayerGameStatisticBox() async {
    return await Hive.openBox<PlayerGameStatisticModel>(
      _playerGameStatisticBoxName,
    );
  }

  // Create or update playerGameStatistic
  static Future<void> addOrUpdatePlayerGameStatistics(
    List<PlayerGameStatisticModel> playerGameStatistics,
  ) async {
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    await playerGameStatisticBox.putAll({
      for (var stat in playerGameStatistics) stat.id: stat,
    });
  }

  static Future<void> addOrUpdatePlayerGameStatistic(
    PlayerGameStatisticModel playerGameStatistic,
  ) async {
    await addOrUpdatePlayerGameStatistics([playerGameStatistic]);
  }

  // Get all playerGameStatistics
  static Future<List<PlayerGameStatisticModel>>
  getAllPlayerGameStatistics() async {
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    return playerGameStatisticBox.values.toList();
  }

  // Delete playerGameStatistic
  static Future<void> deletePlayerGameStatistic(String id) async {
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    await playerGameStatisticBox.delete(id);
  }

  // Get playerGameStatistics by Id
  static Future<List<PlayerGameStatisticModel>> getPlayerGameStatistics(
    List<String> ids,
  ) async {
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    return playerGameStatisticBox.values
        .where((p) => ids.contains(p.id))
        .toList();
  }

  static Future<PlayerGameStatisticModel?> getPlayerGameStatistic(
    String id,
  ) async {
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    return playerGameStatisticBox.values.where((p) => id == p.id).firstOrNull;
  }

  static Future<List<PlayerGameStatisticModel>> getPlayerGameStatisticsForGame(
    String gameId,
  ) async {
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    return playerGameStatisticBox.values
        .where((p) => p.gameId == gameId)
        .toList();
  }

  static Future<void> deletePlayerGameStatisticsForGame(String gameId) async {
    final models = await getPlayerGameStatisticsForGame(gameId);
    if (models.isEmpty) {
      return;
    }
    final playerGameStatisticBox = await _getPlayerGameStatisticBox();
    await playerGameStatisticBox.deleteAll(models.map((m) => m.id));
  }
}
