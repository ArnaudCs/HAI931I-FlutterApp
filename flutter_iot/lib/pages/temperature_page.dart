import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/models/temperature_model.dart';
import 'package:flutter_iot/models/threshold_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/data_gauge.dart';
import 'package:flutter_iot/utils/icon_button.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  List<String> actualUsedDevice = [];
  bool _dataFetched = false;
  late SensorService _temperatureService;
  DateTime now = DateTime.now();
  Temperature? _temperature;
  late Thresholds thresholds;
  late double minThreshold = 0.0;
  late double maxThreshold = 0.0;
  String deviceName = '';

  Future<void> loadUsedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    deviceName = '${actualUsedDevice[0]} - ${actualUsedDevice[1]}';
    String baseUrl = 'http://${actualUsedDevice[3]}';
    String apiUrl = '$baseUrl/threshold';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        thresholds = Thresholds.fromJson(jsonResponse);
        minThreshold = thresholds.TempMin.toDouble();
        maxThreshold = thresholds.TempMax.toDouble();
      } else {
        print('Error receiving data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the request: $error');
    }
    setState(() {});
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _initTemperatureService() async {
    await loadUsedDevice();
    _temperatureService = SensorService('temperature', actualUsedDevice.isNotEmpty ? actualUsedDevice[3] : '');
  }

  Future<void> _fetchTemperature() async {
    try {
      await _initTemperatureService(); 
      final temperature = await _temperatureService.getSensorData();
      await _updateFirestore(temperature);
      setState(() {
        _temperature = temperature;
        _dataFetched = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTemperature();
  }

  Future<void> _updateFirestore(Temperature temperature) async {
    CollectionReference temperatureCollection = _firestore.collection('$deviceName - Temp');
    DateTime now = DateTime.now();
    String sensorId = actualUsedDevice.isNotEmpty ? deviceName : '';
    Map<String, dynamic> data = {
      'sensorId': sensorId,
      'temperature': temperature.temperature,
      'date': DateTime.now(),
    };

    await temperatureCollection.doc(now.toString()).set(data, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageTopCard(
                prefixTitle: '',
                title: 'Temperature',
                subTitle: 'About temperature',
                color1: Colors.blueAccent,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the temperature around your plant. The temperature is measured in degrees Celsius. The higher the value, the warmer your plant is',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: _dataFetched
                  ? _temperature != null
                      ? DataGauge(
                          temperature: _temperature!.temperature.toDouble(),
                          minThreshold: minThreshold,
                          maxThreshold: maxThreshold,
                        )
                      : const DataGauge(
                        temperature: 0.0,
                        minThreshold: 0.0,
                        maxThreshold: 15,
                      )
                  : const CircularProgressIndicator(),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GestureDetector(
                  onTap: () async {
                    await _fetchTemperature();
                  },
                  child: const SimpleIconButton(
                    buttonIcon: Icons.refresh,
                    buttonText: 'Refresh',
                  ),
                )
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}