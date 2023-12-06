class BrightnessModel{

  final double brightness;

  BrightnessModel({
    required this.brightness, 
  });

  //Here i'm decoding the data from the API Call
  factory BrightnessModel.fromJson(Map<String, dynamic> json){
    return BrightnessModel(brightness: json['luminosity']);
  }
}