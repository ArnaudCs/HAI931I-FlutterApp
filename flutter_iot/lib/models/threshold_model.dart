class Thresholds {
  late int _minTemp;
  late int _maxTemp;
  late int _minBrightness;
  late int _maxBrightness;
  late int _waterTime;

  Thresholds({
    int minTemp = 0,
    int maxTemp = 0,
    int minBrightness = 0,
    int maxBrightness = 0,
    int waterTime = 0,
  })  : _minTemp = minTemp,
        _maxTemp = maxTemp,
        _minBrightness = minBrightness,
        _maxBrightness = maxBrightness,
        _waterTime = waterTime;

  int get minTemp => _minTemp;
  set minTemp(int value) => _minTemp = value;

  int get maxTemp => _maxTemp;
  set maxTemp(int value) => _maxTemp = value;

  int get minBrightness => _minBrightness;
  set minBrightness(int value) => _minBrightness = value;

  int get maxBrightness => _maxBrightness;
  set maxBrightness(int value) => _maxBrightness = value;

  int get waterTime => _waterTime;
  set waterTime(int value) => _waterTime = value;

  Map<String, dynamic> toJson() {
    return {
      'minTemp': _minTemp,
      'maxTemp': _maxTemp,
      'minBrightness': _minBrightness,
      'maxBrightness': _maxBrightness,
      'waterTime': _waterTime,
    };
  }

  factory Thresholds.fromJson(Map<String, dynamic> json) {
    return Thresholds(
      minTemp: json['TempMin'] as int,
      maxTemp: json['TempMax'] as int,
      minBrightness: json['LumMin'] as int,
      maxBrightness: json['LumMax'] as int,
      waterTime: json['WaterTime'] as int,
    );
  }
}