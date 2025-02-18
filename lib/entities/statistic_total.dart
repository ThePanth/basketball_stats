import 'package:basketball_stats/entities/statistic_item.dart';
import 'package:basketball_stats/models/statistic_type.dart';

class StatisticTotal {
  int twoPointSuccessCount;
  int twoPointMissCount;
  int threePointSuccessCount;
  int threePointMissCount;
  int reboundCount;
  int assistCount;

  StatisticTotal({
    required this.twoPointSuccessCount,
    required this.twoPointMissCount,
    required this.threePointSuccessCount,
    required this.threePointMissCount,
    required this.reboundCount,
    required this.assistCount,
  });

  static StatisticTotal of(List<StatisticItem> items) {
    return StatisticTotal(
      twoPointSuccessCount:
          items.where((i) => i.type == StatisticsType.twoPointSuccess).length,
      twoPointMissCount:
          items.where((i) => i.type == StatisticsType.twoPointMiss).length,
      threePointSuccessCount:
          items.where((i) => i.type == StatisticsType.threePointSuccess).length,
      threePointMissCount:
          items.where((i) => i.type == StatisticsType.threePointMiss).length,
      reboundCount: items.where((i) => i.type == StatisticsType.rebound).length,
      assistCount: items.where((i) => i.type == StatisticsType.assist).length,
    );
  }

  int getTotalPoints() {
    return 3 * threePointSuccessCount + 2 * twoPointSuccessCount;
  }

  double getTwoPointsSuccessPercentage() {
    return twoPointSuccessCount / (twoPointMissCount + twoPointSuccessCount);
  }

  double getThreePointsSuccessPercentage() {
    return twoPointSuccessCount / (twoPointMissCount + twoPointSuccessCount);
  }
}
