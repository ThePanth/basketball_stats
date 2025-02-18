import 'package:basketball_stats/entities/player.dart';
import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/entities/statistic_total.dart';
import 'package:basketball_stats/entities/team.dart';
import 'package:basketball_stats/models/game_model.dart';
import 'package:basketball_stats/models/statistic_type.dart';

class Game {
  String id;
  DateTime startTime;
  DateTime? endTime;
  Team firstTeam;
  Team secondTeam;
  List<StatisticItem> firstTeamStatistic;
  List<StatisticItem> secondTeamStatistic;
  List<Player> players;
  Map<String, List<StatisticItem>> playerStatistics;

  Game({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.firstTeam,
    required this.secondTeam,
    required this.firstTeamStatistic,
    required this.secondTeamStatistic,
    required this.players,
    required this.playerStatistics,
  });

  StatisticTotal getPlayerTotalStatistic(String playerId) {
    final statistic = playerStatistics[playerId] ?? [];
    return StatisticTotal.of(statistic);
  }

  StatisticTotal getFirstTeamTotalStatistic() {
    return StatisticTotal.of(firstTeamStatistic);
  }

  StatisticTotal getSecondTeamTotalStatistic() {
    return StatisticTotal.of(secondTeamStatistic);
  }

  void addStatisticItem(String playerId, StatisticsType type) {
    final isFirstTeamPlayer = firstTeam.players.any((p) => p.id == playerId);
    final item = StatisticItem(
      type: type,
      timestamp: DateTime.now(),
      gameId: id,
      teamId: isFirstTeamPlayer ? firstTeam.id : secondTeam.id,
      playerId: playerId,
    );

    playerStatistics[playerId]!.add(item);
    if (isFirstTeamPlayer) {
      firstTeamStatistic.add(item);
    } else {
      secondTeamStatistic.add(item);
    }
  }

  static Game of(
    GameModel m,
    Team firstTeam,
    Team secondTeam,
    List<StatisticItem> statItems,
  ) {
    final players = firstTeam.players + secondTeam.players;
    final firstTeamStatistic =
        statItems.where((i) => i.teamId == firstTeam.id).toList()
          ..sort((i1, i2) => i1.timestamp.compareTo(i2.timestamp));
    final secondTeamStatistic =
        statItems.where((i) => i.teamId == secondTeam.id).toList()
          ..sort((i1, i2) => i1.timestamp.compareTo(i2.timestamp));
    final playerStatistics = {
      for (var playerId in players.map((p) => p.id))
        playerId:
            statItems.where((i) => i.playerId == playerId).toList()
              ..sort((i1, i2) => i1.timestamp.compareTo(i2.timestamp)),
    };

    return Game(
      id: m.id,
      startTime: m.startTime,
      endTime: m.endTime,
      firstTeam: firstTeam,
      secondTeam: secondTeam,
      firstTeamStatistic: firstTeamStatistic,
      secondTeamStatistic: secondTeamStatistic,
      players: players,
      playerStatistics: playerStatistics,
    );
  }

  GameModel toModel() {
    return GameModel(
      id: id,
      startTime: startTime,
      firstTeamId: firstTeam.id,
      secondTeamId: secondTeam.id,
      endTime: endTime,
    );
  }
}
