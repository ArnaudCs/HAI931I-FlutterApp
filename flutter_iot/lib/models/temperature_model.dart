class Temperature{

  final double temperature;

  Temperature({
    required this.temperature, 
  });

  //Here i'm decoding the data from the API Call
  factory Temperature.fromJson(Map<String, dynamic> json){
    return Temperature(temperature: json['temperature']);
  }
}