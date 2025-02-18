import 'package:basketball_stats/models/team_model.dart';
import 'package:hive/hive.dart';

class TeamRepository {
  static const _teamBoxName = 'teams';

  // Get team box
  static Future<Box<TeamModel>> _getTeamBox() async {
    return await Hive.openBox<TeamModel>(_teamBoxName);
  }

  // Create or update team
  static Future<void> addOrUpdateTeam(TeamModel team) async {
    final teamBox = await _getTeamBox();
    await teamBox.put(team.id, team);  // If id exists, it updates the team
  }

  // Get all teams
  static Future<List<TeamModel>> getAllTeams() async {
    final teamBox = await _getTeamBox();
    return teamBox.values.toList();
  }

  // Delete team
  static Future<void> deleteTeam(String id) async {
    final teamBox = await _getTeamBox();
    await teamBox.delete(id);
  }

  // Get teams by Id
  static Future<List<TeamModel>> getTeams(List<String> ids) async {
    final teamBox = await _getTeamBox();
    return teamBox.values.where((p) => ids.contains(p.id)).toList();
  }

  static Future<TeamModel> getTeam(String id) async {
    final teamBox = await _getTeamBox();
    return teamBox.values.where((p) => id == p.id).first;
  }
}
