import 'package:flutter_iot/models/brightness_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BrightnessService{
  static const BASE_URL = 'http://10.193.101.132:3000/brightness';
  
  BrightnessService();

  Future<BrightnessModel> getBrightness() async{
    final response = await http.get(Uri.parse('$BASE_URL'));
    if(response.statusCode == 200){
      return BrightnessModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error fetching brightness');
    }
  }
}