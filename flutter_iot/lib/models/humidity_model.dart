class Humidity{

  final double humidity;

  Humidity({
    required this.humidity, 
  });

  //Here i'm decoding the data from the API Call
  factory Humidity.fromJson(Map<String, dynamic> json){
    return Humidity(humidity: json['humidity']);
  }
}