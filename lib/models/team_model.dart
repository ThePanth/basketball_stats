import 'package:basketball_stats/models/adapters_type.dart';
import 'package:hive/hive.dart';

part 'team_model.g.dart';

@HiveType(typeId: AdapterType.team)
class TeamModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<String> playerIds;
  
  TeamModel({required this.id, required this.name, required this.playerIds });
}