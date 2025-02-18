import 'package:basketball_stats/models/adapters_type.dart';
import 'package:hive/hive.dart';

part 'player_model.g.dart';

@HiveType(typeId: AdapterType.player)
class PlayerModel {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;
  
  @HiveField(3)
  final int badgeColor;  // Add this field

  PlayerModel({required this.id, required this.firstName, required this.lastName, required this.badgeColor});
}