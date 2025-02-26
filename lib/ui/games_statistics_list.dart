import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/models/statistic_type.dart';
import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:flutter/material.dart';

class GamesStatisticsList extends StatefulWidget {
  final Map<String, List<PlayerStat>> gameStatistics;
  final String? initialGameKey;
  const GamesStatisticsList({
    required this.gameStatistics,
    this.initialGameKey,
    Key? key,
  }) : super(key: key);

  @override
  _GamesStatisticsListState createState() => _GamesStatisticsListState();
}

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

class PlayerStat {
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

  PlayerStat({
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

  static PlayerStat of(
    List<StatisticItem> items,
    String playerName,
    String teamName,
  ) {
    return PlayerStat(
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

  PlayerStat operator +(PlayerStat other) {
    if (this.playerName != other.playerName) {
      throw Exception("Cannot add different players");
    }
    return PlayerStat(
      playerName: playerName,
      teamName: teamName,
      twoPointSuccess: twoPointSuccess + other.twoPointSuccess,
      twoPointMiss: twoPointMiss + other.twoPointMiss,
      twoPointTotal: twoPointTotal + other.twoPointTotal,
      threePointSuccess: threePointSuccess + other.threePointSuccess,
      threePointMiss: threePointMiss + other.threePointMiss,
      threePointTotal: threePointTotal + other.threePointTotal,
      totalPoints: totalPoints + other.totalPoints,
      rebound: rebound + other.rebound,
      assist: assist + other.assist,
    );
  }
}

class _GamesStatisticsListState extends State<GamesStatisticsList> {
  late String _selectedGame;
  _ColumnType _sortColumn = _ColumnType.playerName;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  _initState() async {
    setState(() {
      _selectedGame = widget.initialGameKey ?? widget.gameStatistics.keys.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown selector
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedGame,
            items:
                widget.gameStatistics.keys
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _selectedGame = value;
                });
              }
            },
          ),
        ),

        // Scrollable table
        //Expanded(
        /*child: */ SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: DataTable(
            columnSpacing: 20, // Space between columns
            columns:
                _ColumnType.values.map((t) => _buildSortableColumn(t)).toList(),
            rows: _buildPlayerRows(),
          ),
        ),
        //),
      ],
    );
  }

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
      _ColumnType.playerName => tr("Name"),
      _ColumnType.totalScore => tr("Points"),
      _ColumnType.twoPointsSuccess => tr("2P"),
      _ColumnType.twoPointsPercentage => tr("2P %"),
      _ColumnType.threePointsSuccess => tr("3P"),
      _ColumnType.threePointsPercentage => tr("3P %"),
      _ColumnType.rebound => tr("Rebounds"),
      _ColumnType.assist => tr("Assists"),
    };
  }

  void _sortData(_ColumnType column) {
    final isAscending = _sortColumn == column ? !_isAscending : true;
    final sortColumn = column;

    setState(() {
      _sortColumn = sortColumn;
      _isAscending = isAscending;
      for (var gameStat in widget.gameStatistics.values) {
        gameStat.sort(_sortFunc);
      }
    });
  }

  int _sortFunc(PlayerStat p1, PlayerStat p2) {
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

  List<DataRow> _buildPlayerRows() {
    List<DataRow> rows =
        widget.gameStatistics[_selectedGame]!
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

  DataRow _buildTotalRow() {
    final gameStat = widget.gameStatistics[_selectedGame]!;
    int twoPointSuccess = gameStat.fold(0, (sum, p) => sum + p.twoPointSuccess);
    int twoPointTotal = gameStat.fold(0, (sum, p) => sum + p.twoPointTotal);
    int threePointSuccess = gameStat.fold(
      0,
      (sum, p) => sum + p.threePointSuccess,
    );
    int threePointTotal = gameStat.fold(0, (sum, p) => sum + p.threePointTotal);

    return DataRow(
      cells:
          _ColumnType.values
              .map(
                (t) => switch (t) {
                  _ColumnType.playerName => tr("Total"),
                  _ColumnType.totalScore =>
                    gameStat
                        .fold(0, (sum, p) => sum + p.totalPoints)
                        .toString(),
                  _ColumnType.twoPointsSuccess =>
                    "$twoPointSuccess/$twoPointTotal",
                  _ColumnType.twoPointsPercentage =>
                    (twoPointTotal == 0
                            ? 0
                            : ((twoPointSuccess / twoPointTotal) * 100).round())
                        .toString(),
                  _ColumnType.threePointsSuccess =>
                    "$threePointSuccess/$threePointTotal",
                  _ColumnType.threePointsPercentage =>
                    (threePointTotal == 0
                            ? 0
                            : ((threePointSuccess / threePointTotal) * 100)
                                .round())
                        .toString(),
                  _ColumnType.rebound =>
                    gameStat.fold(0, (sum, p) => sum + p.rebound).toString(),
                  _ColumnType.assist =>
                    gameStat.fold(0, (sum, p) => sum + p.assist).toString(),
                },
              )
              .map((s) => DataCell(Text(s)))
              .toList(),
    );
  }
}
