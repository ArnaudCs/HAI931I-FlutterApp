import 'package:flutter_iot/models/temperature_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TemperatureService{
  static const BASE_URL = 'http://10.193.101.132:3000/humidity';
  
  TemperatureService();

  Future<Temperature> getTemperature() async{
    final response = await http.get(Uri.parse('$BASE_URL'));
    if(response.statusCode == 200){
      return Temperature.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error fetching temperature');
    }
  }
}