class Watering {
  final double timeBeforeWatering;

  Watering({
    required this.timeBeforeWatering,
  });

  factory Watering.fromJson(Map<String, dynamic> json) {
    final double beforeWateringValue = (json['timeBeforeWater'] as num).toDouble();
    return Watering(timeBeforeWatering: beforeWateringValue);
  }
}