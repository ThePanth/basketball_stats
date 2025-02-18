import 'package:basketball_stats/models/game_model.dart';
import 'package:basketball_stats/models/player_model.dart';
import 'package:basketball_stats/models/player_game_statistic_model.dart';
import 'package:basketball_stats/models/statistic_model.dart';
import 'package:basketball_stats/models/team_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void registerAddapters() {
  // Register the Player adapter
  Hive.registerAdapter(PlayerModelAdapter());
  Hive.registerAdapter(GameModelAdapter());
  Hive.registerAdapter(TeamModelAdapter());
  Hive.registerAdapter(PlayerGameStatisticModelAdapter());
  Hive.registerAdapter(StatisticModelAdapter());
}
