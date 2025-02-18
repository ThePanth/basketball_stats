import 'package:basketball_stats/entities/team.dart';
import 'package:basketball_stats/models/team_model.dart';
import 'package:basketball_stats/repositories/team_repository.dart';
import 'package:basketball_stats/services/player_service.dart';

class TeamService {
  static Future<void> addOrUpdateTeam(Team team) async {
    await TeamRepository.addOrUpdateTeam(team.toModel());
  }

  // Get all teams
  static Future<List<Team>> getAllTeams() async {
    final models = await TeamRepository.getAllTeams();
    return Future.wait(models.map((m) => _fillTeam(m)));
  }

  // Delete team
  static Future<void> deleteTeam(String id) async {
    await TeamRepository.deleteTeam(id);
  }

  // Get teams by Id
  static Future<List<Team>> getTeams(List<String> ids) async {
    final models = await TeamRepository.getTeams(ids);
    return Future.wait(models.map((m) => _fillTeam(m)));
  }

  static Future<Team> getTeam(String id) async {
    final m = await TeamRepository.getTeam(id);
    return await _fillTeam(m);
  }

  static Future<Team> _fillTeam(TeamModel m) async {
    final players = await PlayerService.getPlayers(m.playerIds);
    return Team.of(m, players);
  }
}
