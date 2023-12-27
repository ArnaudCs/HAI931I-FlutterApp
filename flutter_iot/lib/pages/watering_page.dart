import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/models/threshold_model.dart';
import 'package:flutter_iot/models/watering_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/brightness_gauge.dart';
import 'package:flutter_iot/utils/icon_button.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:flutter_iot/utils/waiting_data_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WateringPage extends StatefulWidget {
  const WateringPage({super.key});

  @override
  State<WateringPage> createState() => _WateringPageState();
}

class _WateringPageState extends State<WateringPage> {
  List<String> actualUsedDevice = [];
  bool _dataFetched = false;
  late SensorService _wateringService;
  DateTime now = DateTime.now();
  Watering? _timeBeforeWatering;
  late Thresholds thresholds;
  double wateringThreshold = 0.0;
  String deviceName = '';
  late Timer _timer;
  double maxValue = 0.0;
  bool waterNeeded = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUsedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    deviceName = '${actualUsedDevice[0]} - ${actualUsedDevice[1]}';
    String baseUrl = 'http://${actualUsedDevice[3]}';
    String apiUrl = '$baseUrl/threshold';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        thresholds = Thresholds.fromJson(jsonResponse);
        wateringThreshold = thresholds.WaterTime.toDouble();
      } else {
        print('Error receiving data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the request: $error');
    }
    setState(() {});
  }

  Future<void> _addAlert() async {
    CollectionReference waterAlertCollection = _firestore.collection('$deviceName - Alerts');
    DateTime now = DateTime.now();
    String sensorId = actualUsedDevice.isNotEmpty ? deviceName : '';
    Map<String, dynamic> data = {
      'sensorId': sensorId,
      'title' : 'Your plant needs water !',
      'content': 'Your plant needs water, please water it !',
      'date': DateTime.now(),
    };

    await waterAlertCollection.doc(now.toString()).set(data, SetOptions(merge: true));
  }

  Future<void> _fetchWatering() async {
    try{
      await _initWateringService();
      final wateringTime = await _wateringService.getSensorData();
      setState(() {
        _timeBeforeWatering = wateringTime;
        _dataFetched = true;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWatering();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fetchWatering();
      if(_timeBeforeWatering!.timeBeforeWatering.toInt() <= 0){
        if(waterNeeded == false){
          _addAlert();
        }
        waterNeeded = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void sendWateringCommand() async {
    String baseUrl = 'http://${actualUsedDevice[3]}/water';
    String apiUrl = '$baseUrl';
    try {
      final response = await http.post(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print('Plant is watered !');
        _fetchWatering();
      } else {
        print('Error sending data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the request: $error');
    }
  }

  Future<void> _initWateringService() async {
    await loadUsedDevice();
    _wateringService = SensorService('watering', actualUsedDevice.isNotEmpty ? actualUsedDevice[3] : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageTopCard(
                prefixTitle: '',
                title: 'Watering',
                subTitle: 'About watering',
                color1: Colors.blueAccent,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the watering of your plant, the watering is measured in percentage. The higher the value, the more water your plant has',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              _dataFetched ? 
                  Column(
                    children: [
                      const Text(
                        'Watering Time',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              offset: const Offset(5, 5),
                              blurRadius: 15,
                              spreadRadius: 1.0,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 15,
                              spreadRadius: 1.0,
                            )
                          ],
                        ),
                        child: Text(
                          'Time before watering: ${_timeBeforeWatering?.timeBeforeWatering.toInt() ?? '0'} seconds',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: _dataFetched
                          ? _timeBeforeWatering != null
                              ? DataGauge(
                                brightness: _timeBeforeWatering?.timeBeforeWatering ?? 0.0, 
                                minMarker: 0.0, 
                                maxMarker: 0.0,
                                minValue: 0.0,
                                maxValue: wateringThreshold ?? 120.0,
                              )
                              : const DataGauge(
                                  brightness: 1.0, 
                                  minMarker: 1000.0, 
                                  maxMarker: 9000.0,
                                  minValue: 0.0,
                                  maxValue: 40.0,
                                )
                          : const CircularProgressIndicator(),
                      ),

                      const SizedBox(height: 20),

                      _dataFetched ? 
                        GestureDetector(
                            onTap: () {
                              sendWateringCommand();
                            },
                            child: const SimpleIconButton(
                              buttonIcon: Icons.check,
                              buttonText: 'Watering done',
                            ),
                          ) : const SizedBox(),
                        ],
                  ) : const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: WaitingCard(
                      title: 'Fetching data',
                      subtitle: 'Please wait while we are fetching data from your device, if this takes too long, please check your device connection.',
                      icon: Icons.hourglass_bottom_rounded,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}