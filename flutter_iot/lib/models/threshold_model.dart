class Thresholds {
  late int _TempMin;
  late int _TempMax;
  late int _LumMin;
  late int _LumMax;
  late int _WaterTime;

  Thresholds({
    int TempMin = 0,
    int TempMax = 0,
    int LumMin = 0,
    int LumMax = 0,
    int WaterTime = 0,
  })  : _TempMin = TempMin,
        _TempMax = TempMax,
        _LumMin = LumMin,
        _LumMax = LumMax,
        _WaterTime = WaterTime;

  int get TempMin => _TempMin;
  set TempMin(int value) => _TempMin = value;

  int get TempMax => _TempMax;
  set TempMax(int value) => _TempMax = value;

  int get LumMin => _LumMin;
  set LumMin(int value) => _LumMin = value;

  int get LumMax => _LumMax;
  set LumMax(int value) => _LumMax = value;

  int get WaterTime => _WaterTime;
  set WaterTime(int value) => _WaterTime = value;

  Map<String, dynamic> toJson() {
    return {
      'TempMin': _TempMin,
      'TempMax': _TempMax,
      'LumMin': _LumMin,
      'LumMax': _LumMax,
      'WaterTime': _WaterTime,
    };
  }

  factory Thresholds.fromJson(Map<String, dynamic> json) {
    return Thresholds(
      TempMin: json['TempMin'] as int,
      TempMax: json['TempMax'] as int,
      LumMin: json['LumMin'] as int,
      LumMax: json['LumMax'] as int,
      WaterTime: json['WaterTime'] as int,
    );
  }
}