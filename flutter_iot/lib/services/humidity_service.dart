import 'package:flutter_iot/models/humidity_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HumidityService{
  static const BASE_URL = 'http://10.193.101.132:3000/humidity';
  
  HumidityService();

  Future<Humidity> getHumidity() async{
    final response = await http.get(Uri.parse('$BASE_URL'));
    if(response.statusCode == 200){
      return Humidity.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error fetching humidity');
    }
  }
}