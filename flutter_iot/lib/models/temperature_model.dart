class Temperature {
  final double temperature;

  Temperature({
    required this.temperature,
  });

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(temperature: (json['currentTemp'] as num).toDouble());
  }
}