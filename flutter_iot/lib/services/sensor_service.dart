import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/models/temperature_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorService {
  static const BASE_URL = 'http://10.193.101.132:3000';

  final String type;

  SensorService(this.type);

  Future<dynamic> getSensorData() async {
    final response = await http.get(Uri.parse('$BASE_URL/$type'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (type == 'temperature') {
        return Temperature.fromJson(jsonData);
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