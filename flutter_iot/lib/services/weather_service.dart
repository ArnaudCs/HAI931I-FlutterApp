import 'package:flutter_iot/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService{

  // ignore: constant_identifier_names
  static const BASE_URL = 'http://10.193.101.132:3000';
  //static const BASE_URL = 'http://VOTRE_IP:3000'; 

  WeatherService();

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL/data'));
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error fetching weather');
    }
  }

  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, 
      position.longitude
    );

    String? city = placemarks[0].locality;

    //?? means if null, so if the city is null, return 'Unknown'
    return city ?? 'Unknown';
  }
}