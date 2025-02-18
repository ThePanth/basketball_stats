import 'package:basketball_stats/models/statistic_model.dart';
import 'package:basketball_stats/models/statistic_type.dart';

class StatisticItem {
  StatisticsType type;
  DateTime timestamp;
  String gameId;
  String teamId;
  String playerId;

  StatisticItem({
    required this.type,
    required this.timestamp,
    required this.gameId,
    required this.teamId,
    required this.playerId,
  });

  static StatisticItem of(
    StatisticModel m,
    String gameId,
    String teamId,
    String playerId,
  ) {
    return StatisticItem(
      type: m.type,
      timestamp: m.timestamp,
      gameId: gameId,
      teamId: teamId,
      playerId: playerId,
    );
  }

  StatisticModel toModel() {
    return StatisticModel(typeIndex: type.index, timestamp: timestamp);
  }
}
