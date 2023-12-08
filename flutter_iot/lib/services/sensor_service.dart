import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/models/humidity_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorService {
  static const BASE_URL = 'http://192.168.1.17:3000';

  final String type;

  SensorService(this.type);

  Future<dynamic> getSensorData() async {
    final response = await http.get(Uri.parse('$BASE_URL/$type'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (type == 'humidity') {
        return Humidity.fromJson(jsonData);
      } else if (type == 'brightness') {
        return BrightnessModel.fromJson(jsonData);
      } else {
        throw Exception('Invalid sensor type');
      }
    } else {
      throw Exception('Error fetching sensors values');
    }
  }
}