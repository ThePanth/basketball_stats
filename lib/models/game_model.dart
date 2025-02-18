import 'package:basketball_stats/models/adapters_type.dart';
import 'package:hive/hive.dart';

part 'game_model.g.dart';

@HiveType(typeId: AdapterType.game)
class GameModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime startTime;
  @HiveField(2)
  DateTime? endTime;
  @HiveField(3)
  String firstTeamId;
  @HiveField(4)
  String secondTeamId;

  GameModel({
    required this.id,
    required this.startTime,
    required this.firstTeamId,
    required this.secondTeamId,
    this.endTime,
  });
}
