import 'package:basketball_stats/models/adapters_type.dart';
import 'package:basketball_stats/models/statistic_model.dart';
import 'package:hive/hive.dart';

part 'player_game_statistic_model.g.dart';

@HiveType(typeId: AdapterType.playerGameStatistic)
class PlayerGameStatisticModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String playerId;
  @HiveField(2)
  String gameId;
  @HiveField(3)
  String teamId;
  @HiveField(4)
  List<StatisticModel> statisticItems;

  PlayerGameStatisticModel({
    required this.id,
    required this.playerId,
    required this.gameId,
    required this.teamId,
    required this.statisticItems,
  });
}
