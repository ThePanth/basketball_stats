import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/models/statistic_type.dart';
import 'package:basketball_stats/services/game_service.dart';
import 'package:flutter/material.dart';

class GameStatisticsScreen extends StatefulWidget {
  final String gameId;
  const GameStatisticsScreen({required this.gameId, Key? key})
    : super(key: key);

  @override
  _GameStatisticsScreenState createState() => _GameStatisticsScreenState();
}

enum _SortOrder { asc, desc }

enum _ColumnType {
  playerName,
  totalScore,
  twoPointsSuccess,
  twoPointsPercentage,
  threePointsSuccess,
  threePointsPercentage,
  rebound,
  assist,
}

class _PlayerStat {
  String playerName;
  String teamName;
  int twoPointSuccess;
  int twoPointMiss;
  int twoPointTotal;
  int threePointSuccess;
  int threePointMiss;
  int threePointTotal;
  int totalPoints;
  int rebound;
  int assist;

  _PlayerStat({
    required this.playerName,
    required this.teamName,
    required this.twoPointSuccess,
    required this.twoPointMiss,
    required this.twoPointTotal,
    required this.threePointSuccess,
    required this.threePointMiss,
    required this.threePointTotal,
    required this.totalPoints,
    required this.rebound,
    required this.assist,
  });

  static _PlayerStat of(
    List<StatisticItem> items,
    String playerName,
    String teamName,
  ) {
    return _PlayerStat(
      playerName: playerName,
      teamName: teamName,
      twoPointSuccess:
          items.where((i) => i.type == StatisticsType.twoPointSuccess).length,
      twoPointMiss:
          items.where((i) => i.type == StatisticsType.twoPointMiss).length,
      twoPointTotal:
          items
              .where(
                (i) =>
                    i.type == StatisticsType.twoPointSuccess ||
                    i.type == StatisticsType.twoPointMiss,
              )
              .length,
      threePointSuccess:
          items.where((i) => i.type == StatisticsType.threePointSuccess).length,
      threePointMiss:
          items.where((i) => i.type == StatisticsType.threePointMiss).length,
      threePointTotal:
          items
              .where(
                (i) =>
                    i.type == StatisticsType.threePointSuccess ||
                    i.type == StatisticsType.threePointMiss,
              )
              .length,
      totalPoints: items.fold(0, (sum, i) {
        if (i.type == StatisticsType.twoPointSuccess) {
          sum += 2;
        }
        if (i.type == StatisticsType.threePointSuccess) {
          sum += 3;
        }
        return sum;
      }),
      rebound: items.where((i) => i.type == StatisticsType.rebound).length,
      assist: items.where((i) => i.type == StatisticsType.assist).length,
    );
  }

  int twoPointsPercentage() {
    return twoPointTotal == 0
        ? 0
        : ((twoPointSuccess / twoPointTotal) * 100).round();
  }

  int threePointsPercentage() {
    return threePointTotal == 0
        ? 0
        : ((threePointSuccess / threePointTotal) * 100).round();
  }
}

class _GameStatisticsScreenState extends State<GameStatisticsScreen> {
  int _selectedTeamIndex = 0; // Default selection
  late List<_PlayerStat> _statistics;
  late Game _game;
  _ColumnType _sortColumn = _ColumnType.playerName;
  bool _isAscending = true;
  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  _loadGame() async {
    final game = await GameService.getGame(widget.gameId);
    final statistics =
        [game.firstTeam, game.secondTeam]
            .map(
              (t) => t.players.map(
                (p) => _PlayerStat.of(
                  game.playerStatistics[p.id]!,
                  p.firstName,
                  t.name,
                ),
              ),
            )
            .expand((e) => e)
            .toList()
          ..sort((p1, p2) => p1.playerName.compareTo(p2.playerName));
    setState(() {
      _game = game;
      _statistics = statistics;
    });
  }

  // Example data (Replace with real data)

  @override
  Widget build(BuildContext context) {
    final dropDownItems = [
      "All teams",
      _game.firstTeam.name,
      _game.secondTeam.name,
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Game Statistics")),
      body: Column(
        children: [
          // Dropdown selector
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              value: _selectedTeamIndex,
              items: List.generate(
                3,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(dropDownItems[index]),
                ),
              ),
              onChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    _selectedTeamIndex = value;
                  });
                }
              },
            ),
          ),
          // Scrollable table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: DataTable(
                columnSpacing: 20, // Space between columns
                columns:
                    _ColumnType.values
                        .map((t) => _buildSortableColumn(t))
                        .toList(),
                rows: _buildPlayerRows(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a clickable column header with sorting arrow
  DataColumn _buildSortableColumn(_ColumnType columnType) {
    return DataColumn(
      label: InkWell(
        onTap: () => _sortData(columnType),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_getColumnTitle(columnType)),
            if (_sortColumn == columnType)
              Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  String _getColumnTitle(_ColumnType type) {
    return switch (type) {
      _ColumnType.playerName => "Name",
      _ColumnType.totalScore => "Points",
      _ColumnType.twoPointsSuccess => "2P",
      _ColumnType.twoPointsPercentage => "2P %",
      _ColumnType.threePointsSuccess => "3P",
      _ColumnType.threePointsPercentage => "3P %",
      _ColumnType.rebound => "R",
      _ColumnType.assist => "A",
    };
  }

  void _sortData(_ColumnType column) {
    final isAscending = _sortColumn == column ? !_isAscending : true;
    final sortColumn = column;

    setState(() {
      _sortColumn = sortColumn;
      _isAscending = isAscending;
      _statistics.sort(_sortFunc);
    });
  }

  int _sortFunc(_PlayerStat p1, _PlayerStat p2) {
    return switch (_sortColumn) {
      _ColumnType.playerName =>
        _isAscending
            ? p1.playerName.compareTo(p2.playerName)
            : p2.playerName.compareTo(p1.playerName),
      _ColumnType.totalScore =>
        !_isAscending
            ? p1.totalPoints.compareTo(p2.totalPoints)
            : p2.totalPoints.compareTo(p1.totalPoints),
      _ColumnType.twoPointsSuccess =>
        !_isAscending
            ? p1.twoPointSuccess.compareTo(p2.twoPointSuccess)
            : p2.twoPointSuccess.compareTo(p1.twoPointSuccess),
      _ColumnType.twoPointsPercentage =>
        !_isAscending
            ? p1.twoPointsPercentage().compareTo(p2.twoPointsPercentage())
            : p2.twoPointsPercentage().compareTo(p1.twoPointsPercentage()),
      _ColumnType.threePointsSuccess =>
        !_isAscending
            ? p1.threePointSuccess.compareTo(p2.threePointSuccess)
            : p2.threePointSuccess.compareTo(p1.threePointSuccess),
      _ColumnType.threePointsPercentage =>
        !_isAscending
            ? p1.threePointsPercentage().compareTo(p2.threePointsPercentage())
            : p2.threePointsPercentage().compareTo(p1.threePointsPercentage()),
      _ColumnType.rebound =>
        !_isAscending
            ? p1.rebound.compareTo(p2.rebound)
            : p2.rebound.compareTo(p1.rebound),
      _ColumnType.assist =>
        !_isAscending
            ? p1.assist.compareTo(p2.assist)
            : p2.assist.compareTo(p1.assist),
    };
  }

  /// Build rows for the table, including player stats and the final aggregated row
  List<DataRow> _buildPlayerRows() {
    String selectedTeamName = "";
    if (_selectedTeamIndex == 1) {
      selectedTeamName = _game.firstTeam.name;
    }
    if (_selectedTeamIndex == 2) {
      selectedTeamName = _game.secondTeam.name;
    }
    final playerStats =
        _selectedTeamIndex == 0
            ? _statistics
            : _statistics.where((s) => s.teamName == selectedTeamName).toList();

    List<DataRow> rows =
        playerStats
            .map(
              (p) => DataRow(
                cells:
                    _ColumnType.values
                        .map(
                          (t) => switch (t) {
                            _ColumnType.playerName => p.playerName,
                            _ColumnType.totalScore => p.totalPoints.toString(),
                            _ColumnType.twoPointsSuccess =>
                              "${p.twoPointSuccess}/${p.twoPointTotal}",
                            _ColumnType.twoPointsPercentage =>
                              p.twoPointsPercentage().toString(),
                            _ColumnType.threePointsSuccess =>
                              "${p.threePointSuccess}/${p.threePointTotal}",
                            _ColumnType.threePointsPercentage =>
                              p.threePointsPercentage().toString(),
                            _ColumnType.rebound => p.rebound.toString(),
                            _ColumnType.assist => p.assist.toString(),
                          },
                        )
                        .map((s) => DataCell(Text(s)))
                        .toList(),
              ),
            )
            .toList();

    // Add final aggregated row
    rows.add(_buildTotalRow());
    return rows;
  }

  /// Calculate and return the total row
  DataRow _buildTotalRow() {
    int totalPoints = 0;
    int totalAssists = 0;
    int totalRebounds = 0;
    double avgSuccessRate = 0;
    double avgTwoPointRate = 0;
    double avgThreePointRate = 0;

    return DataRow(
      cells:
          _ColumnType.values
              .map(
                (t) => switch (t) {
                  _ColumnType.playerName => "",
                  _ColumnType.totalScore => "",
                  _ColumnType.twoPointsSuccess => "",
                  _ColumnType.twoPointsPercentage => "",
                  _ColumnType.threePointsSuccess => "",
                  _ColumnType.threePointsPercentage => "",
                  _ColumnType.rebound => "",
                  _ColumnType.assist => "",
                },
              )
              .map((s) => DataCell(Text(s)))
              .toList(),
    );
  }
}
