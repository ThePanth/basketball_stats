enum StatisticsType {
  twoPointSuccess,
  twoPointMiss,
  threePointSuccess,
  threePointMiss,
  rebound,
  assist;

  String getDisplayName() {
    return switch (this) {
      StatisticsType.twoPointSuccess => "2P",
      StatisticsType.twoPointMiss => "missed 2P",
      StatisticsType.threePointSuccess => "3P",
      StatisticsType.threePointMiss => "missed 3P",
      StatisticsType.rebound => "R",
      StatisticsType.assist => "A",
    };
  }
}
