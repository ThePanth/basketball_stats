enum StatisticsType {
  twoPointSuccess,
  twoPointMiss,
  threePointSuccess,
  threePointMiss,
  rebound,
  assist;

  String getDisplayName() {
    return switch (this) {
      StatisticsType.twoPointSuccess => "2-point",
      StatisticsType.twoPointMiss => "missed 2-point",
      StatisticsType.threePointSuccess => "3-point",
      StatisticsType.threePointMiss => "missed 3-point",
      StatisticsType.rebound => "rebound_full",
      StatisticsType.assist => "assist_full",
    };
  }
}
