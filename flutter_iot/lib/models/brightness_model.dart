class BrightnessModel {
  final double brightness;

  BrightnessModel({
    required this.brightness,
  });

  factory BrightnessModel.fromJson(Map<String, dynamic> json) {
    final double brightnessValue = (json['currentLum'] as num).toDouble();
    return BrightnessModel(brightness: brightnessValue);
  }
}
