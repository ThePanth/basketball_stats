import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/models/game_model.dart';
import 'package:basketball_stats/models/player_game_statistic_model.dart';
import 'package:basketball_stats/repositories/game_repository.dart';
import 'package:basketball_stats/repositories/player_game_statistic_repository.dart';
import 'package:basketball_stats/services/team_service.dart';
import 'package:uuid/uuid.dart';

class GameService {
  static Future<Game> getGame(String id) async {
    final m = await GameRepository.getGame(id);
    return _fillGame(m);
  }

  static Future<List<Game>> getGames(List<String> ids) async {
    final models = await GameRepository.getGames(ids);
    return await Future.wait(models.map((m) => _fillGame(m)));
  }

  static Future<List<Game>> getGamesByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final models = await GameRepository.getGamesByDate(startDate, endDate);
    return await Future.wait(models.map((m) => _fillGame(m)));
  }

  static Future<List<Game>> getAllGames() async {
    final models = await GameRepository.getAllGames();
    return await Future.wait(models.map((m) => _fillGame(m)));
  }

  static Future<Game?> getOngoingGame() async {
    final m = await GameRepository.getOngoingGame();
    return m == null ? null : await _fillGame(m);
  }

  static Future<void> deleteGame(String id) async {
    await PlayerGameStatisticRepository.deletePlayerGameStatisticsForGame(id);
    await GameRepository.deleteGame(id);
  }

  static Future<void> addOrUpdateGame(Game g) async {
    final playerGameStatistics =
        [g.firstTeam, g.secondTeam]
            .map(
              (t) => t.players.map(
                (p) => PlayerGameStatisticModel(
                  id: Uuid().v4(),
                  playerId: p.id,
                  gameId: g.id,
                  teamId: t.id,
                  statisticItems:
                      g.playerStatistics[p.id]!
                          .map((i) => i.toModel())
                          .toList(),
                ),
              ),
            )
            .expand((e) => e)
            .toList();
    await PlayerGameStatisticRepository.deletePlayerGameStatisticsForGame(g.id);
    final tasks = [
      PlayerGameStatisticRepository.addOrUpdatePlayerGameStatistics(
        playerGameStatistics,
      ),
      TeamService.addOrUpdateTeam(g.firstTeam),
      TeamService.addOrUpdateTeam(g.secondTeam),
      GameRepository.addOrUpdateGame(g.toModel()),
    ];
    Future.wait(tasks);
  }

  static Future<Game> _fillGame(GameModel m) async {
    final firstTeam = await TeamService.getTeam(m.firstTeamId);
    final secondTeam = await TeamService.getTeam(m.secondTeamId);
    final statistics =
        await PlayerGameStatisticRepository.getPlayerGameStatisticsForGame(
          m.id,
        );

    final statisticItems =
        statistics
            .map(
              (s) => s.statisticItems.map(
                (i) => StatisticItem(
                  type: i.type,
                  timestamp: i.timestamp,
                  gameId: s.gameId,
                  teamId: s.teamId,
                  playerId: s.playerId,
                ),
              ),
            )
            .expand((l) => l)
            .toList();

    return Game.of(m, firstTeam, secondTeam, statisticItems);
  }
}
