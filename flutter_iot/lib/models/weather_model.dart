class Weather{

  final String cityName; 
  final double temperature;
  final String condition;

  Weather({
    required this.cityName, 
    required this.temperature, 
    required this.condition
  });

  //Here i'm decoding the data from the API Call
  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main']
    );
  }
}