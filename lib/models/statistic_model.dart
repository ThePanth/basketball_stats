import 'package:basketball_stats/models/adapters_type.dart';
import 'package:basketball_stats/models/statistic_type.dart';
import 'package:hive/hive.dart';

part 'statistic_model.g.dart';

@HiveType(typeId: AdapterType.statistic)
class StatisticModel {
  @HiveField(0)
  int typeIndex;
  @HiveField(1)
  DateTime timestamp;

  StatisticModel({required this.typeIndex, required this.timestamp});

  StatisticsType get type => StatisticsType.values[typeIndex];
}
