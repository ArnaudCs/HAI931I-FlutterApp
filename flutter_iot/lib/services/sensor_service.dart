import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/models/temperature_model.dart';
import 'package:flutter_iot/models/watering_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorService {
  final String type;
  final String ip;

  SensorService(this.type, this.ip);

  String get baseUrl => 'http://$ip';

  Future<dynamic> getSensorData() async {
    final response = await http.get(Uri.parse('$baseUrl/sensors'));
    print('$baseUrl/sensors');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (type == 'temperature') {
        return Temperature.fromJson(jsonData);
      } else if (type == 'brightness') {
        return BrightnessModel.fromJson(jsonData);
      } else if (type == 'watering') {
        return Watering.fromJson(jsonData);
      } else {
        throw Exception('Invalid sensor type');
      }
    } else {
      throw Exception('Error fetching sensors values');
    }
  }
}