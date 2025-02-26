import 'package:basketball_stats/entities/game.dart';
import 'package:basketball_stats/services/game_service.dart';
import 'package:basketball_stats/ui/games_statistics_list.dart';
import 'package:basketball_stats/utils/app_localizations.dart';
import 'package:basketball_stats/utils/game_notifier.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

enum _DateFilterType {
  day,
  week,
  month,
  customRange;

  @override
  String toString() {
    return switch (this) {
      _DateFilterType.day => tr("Day"),
      _DateFilterType.week => tr("Week"),
      _DateFilterType.month => tr("Month"),
      _DateFilterType.customRange => tr("Custom Range"),
    };
  }
}

class _StatisticsViewState extends State<StatisticsView>
    with WidgetsBindingObserver {
  late _DateFilterType _dateFilterType;
  late DateTime _startDate;
  late DateTime _endDate;
  late Map<String, List<PlayerStat>> _statistics;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setDateFilterType(_DateFilterType.day);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    children.add(
      DropdownButton<_DateFilterType>(
        value: _dateFilterType,
        items:
            _DateFilterType.values
                .map(
                  (f) => DropdownMenuItem(value: f, child: Text(f.toString())),
                )
                .toList(),
        onChanged: (_DateFilterType? value) {
          if (value != null) {
            _setDateFilterType(value);
          }
        },
      ),
    );
    if (_dateFilterType == _DateFilterType.customRange) {
      children.add(_buildDateTimePickers(context, _startDate, _endDate));
    }
    children.add(
      GamesStatisticsList(
        gameStatistics: _statistics,
        initialGameKey: tr("All Games"),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(tr("Statistics"))),
      body: Column(children: children),
    );
  }

  void _setDateFilterType(_DateFilterType dateFilterType) {
    final startDate = switch (dateFilterType) {
      _DateFilterType.day => DateTime.now().add(Duration(days: -1)),
      _DateFilterType.week => DateTime.now().add(Duration(days: -7)),
      _DateFilterType.month => DateTime.now().add(Duration(days: -30)),
      _DateFilterType.customRange => _startDate,
    };

    final endDate = switch (dateFilterType) {
      _DateFilterType.day => DateTime.now(),
      _DateFilterType.week => DateTime.now(),
      _DateFilterType.month => DateTime.now(),
      _DateFilterType.customRange => _endDate,
    };

    _setDateTimeRanges(dateFilterType, startDate, endDate);
  }

  void _setDateTimeRanges(
    _DateFilterType filter,
    DateTime startDate,
    DateTime endDate,
  ) {
    _loadData(filter, startDate, endDate);
  }

  void _loadData(
    _DateFilterType filter,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final games = await GameService.getGamesByDate(startDate, endDate);
    final statistics = {
      for (var g in games)
        DateFormat(
          'd MMMM yyyy HH:mm',
        ).format(g.startTime): _getStatisticsForGame(g),
    };
    final allStats =
        statistics.values
            .expand((element) => element)
            .groupListsBy((e) => e.playerName)
            .map((k, v) => MapEntry(k, v.reduce((a, b) => a + b)))
            .values
            .toList()
          ..sort((a, b) => a.playerName.compareTo(b.playerName));

    statistics[tr("All Games")] = allStats;

    setState(() {
      _dateFilterType = filter;
      _startDate = startDate;
      _endDate = endDate;
      _statistics = statistics;
    });
  }

  List<PlayerStat> _getStatisticsForGame(Game game) {
    final firstTeamStatistics =
        game.firstTeam.players
            .map(
              (p) => PlayerStat.of(
                game.playerStatistics[p.id]!,
                p.firstName,
                game.firstTeam.name,
              ),
            )
            .toList();
    final secondTeamStatistics =
        game.secondTeam.players
            .map(
              (p) => PlayerStat.of(
                game.playerStatistics[p.id] ?? [],
                p.firstName,
                game.firstTeam.name,
              ),
            )
            .toList();

    return (firstTeamStatistics + secondTeamStatistics)
      ..sort((a, b) => a.playerName.compareTo(b.playerName));
  }

  Widget _buildDateTimePickers(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(tr("From")),
        TextButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: startDate,
              firstDate: startDate.add(Duration(days: -365)),
              lastDate: startDate.add(Duration(days: 365)),
            );
            if (date != null) {
              _setDateTimeRanges(_DateFilterType.customRange, date, _endDate);
            }
          },
          child: Text(DateFormat('d MMMM yyyy').format(startDate)),
        ),
        Text(tr("To")),
        TextButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: endDate,
              firstDate: endDate.add(Duration(days: -365)),
              lastDate: endDate.add(Duration(days: 365)),
            );
            if (date != null) {
              _setDateTimeRanges(_DateFilterType.customRange, _startDate, date);
            }
          },
          child: Text(DateFormat('d MMMM yyyy').format(endDate)),
        ),
      ],
    );
  }
}
