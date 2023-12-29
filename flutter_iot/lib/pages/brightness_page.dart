import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/models/chart_data.dart';
import 'package:flutter_iot/models/threshold_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/brightness_gauge.dart';
import 'package:flutter_iot/utils/date_display.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:flutter_iot/utils/icon_button.dart';
import 'package:flutter_iot/utils/spline_chart_card.dart';
import 'package:flutter_iot/utils/waiting_data_card.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BrightnessPage extends StatefulWidget {
  const BrightnessPage({super.key});

  @override
  State<BrightnessPage> createState() => _BrightnessPageState();
}

class _BrightnessPageState extends State<BrightnessPage> {
  List<String> actualUsedDevice = [];
  bool _dataFetched = false;
  late SensorService _brightnessService;
  DateTime now = DateTime.now();
  BrightnessModel? _brightness;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late double minThreshold = 0.0;
  late double maxThreshold = 0.0;
  late Thresholds thresholds;
  String deviceName = '';
  List<ChartData> chartData = [];

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
        minThreshold = thresholds.LumMin.toDouble();
        maxThreshold = thresholds.LumMax.toDouble();
      } else {
        print('Error receiving data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the request: $error');
    }
    setState(() {});
  }

  Future<void> _fetchBrightness() async {
    try{
      await _initBrightnessService();
      final brightness = await _brightnessService.getSensorData();
      await _updateFirestore(brightness);
      setState(() {
        _brightness = brightness;
        if(_brightness!.brightness != null) {
          if(_brightness!.brightness > maxThreshold){
            _addAlert('high');
          } else if (_brightness!.brightness < minThreshold){
            _addAlert('low');
          }
        }
        _dataFetched = true;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBrightness();
  }

  Future<void> _initBrightnessService() async {
    await loadUsedDevice();
    _brightnessService = SensorService('brightness', actualUsedDevice.isNotEmpty ? actualUsedDevice[3] : '');
    _initChartData();
  }

  Future<void> _initChartData() async {
    Map<DateTime, double> brightnessData = await fetchBrightnessData(deviceName);

    chartData = brightnessData.entries.map((entry) {
      return ChartData(date: entry.key, value: entry.value);
    }).toList();

    setState(() {});
  }

  Future<Map<DateTime, double>> fetchBrightnessData(String deviceName) async {
    Map<DateTime, double> brightnessData = {};
    try {
      String collectionPath = '$deviceName - Bright';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionPath).get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('date') && data.containsKey('brightness')) {
          DateTime date = data['date'].toDate();
          double brightness = data['brightness'].toDouble();
          brightnessData[date] = brightness;
        }
      }
    } catch (error) {
      print('Error fetching brightness data: $error');
    }
    return brightnessData;
  }

  Future<void> _addAlert(String alert) async {
    CollectionReference brightnessAlertCollection = _firestore.collection('$deviceName - Alerts');
    DateTime now = DateTime.now();
    String sensorId = actualUsedDevice.isNotEmpty ? deviceName : '';
    Map<String, dynamic> data = {
      'sensorId': sensorId,
      'title' : 'Brightness is to ${alert} !',
      'content': 'Your plant needs ${alert == 'high' ? 'less' : 'more'} luminosity, please check the brightness of your plant.',
      'date': DateTime.now(),
    };

    await brightnessAlertCollection.doc(now.toString()).set(data, SetOptions(merge: true));
  }

  Future<void> _updateFirestore(BrightnessModel brightnessModel) async {
    CollectionReference brightnessCollection = _firestore.collection('$deviceName - Bright');
    DateTime now = DateTime.now();
    String sensorId = actualUsedDevice.isNotEmpty ? deviceName : '';
    Map<String, dynamic> data = {
      'sensorId': sensorId,
      'brightness': brightnessModel.brightness,
      'date': DateTime.now(),
    };

    await brightnessCollection.doc(now.toString()).set(data, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: 
            Column(
              children: [
                PageTopCard(
                  prefixTitle: '',
                  title: 'Brightness',
                  subTitle: 'About brightness',
                  color1: Colors.blue.shade200,
                  color2: Colors.green.shade200,
                  text: 'Here you can monitor the brightness around your plant. The brightness is measured in lux. The higher the value, the more light your plant receives',
                  cornerLeft: 30.0,
                  cornerRight: 30.0,
                ),
                
                const SizedBox(height: 20),

                _dataFetched ?
                  Column(
                    children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        const Text (
                          'Your plant is alive !',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  
                        const SizedBox(height: 30.0),
                  
                        _dataFetched
                          ? _brightness != null
                              ?DataGauge(
                                brightness: _brightness?.brightness ?? 0.0, 
                                minMarker: minThreshold, 
                                maxMarker: maxThreshold,
                                minValue: 0.0,
                                maxValue: 10000.0,
                              )
                              : const DataGauge(
                                  brightness: 1.0, 
                                  minMarker: 1000.0, 
                                  maxMarker: 9000.0,
                                  minValue: 0.0,
                                  maxValue: 9000.0,
                                )
                          : CircularProgressIndicator(),
                  
                        const SizedBox(height: 10.0),
                  
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text(
                              '${_brightness?.brightness.toDouble() ?? 0.0} Lux',
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  
                        const SizedBox(height: 30),
                  
                        DateDisplay()
                        
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _dataFetched ? 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GestureDetector(
                        onTap: () async {
                          await _fetchBrightness();
                        },
                        child: const SimpleIconButton(
                          buttonIcon: Icons.refresh,
                          buttonText: 'Refresh',
                        ),
                      )
                    ) : const SizedBox(),

                  const SizedBox(height: 30),

                  _dataFetched
                      ? _brightness != null
                          ? SplineChartCard(
                              chartTitle: 'Brightness history', 
                              absLabel: 'Date', 
                              ordLabel: 'brightness', 
                              icon: Icons.thermostat_outlined,
                              chartData: chartData
                            ) : const SizedBox() 
                            : const CircularProgressIndicator(),
                    ],
                  ) : const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: WaitingCard(
                      title: 'Fetching data',
                      subtitle: 'Please wait while we are fetching data from your device, if this takes too long, please check your device connection.',
                      icon: Icons.hourglass_bottom_rounded,
                    ),
                  ),

              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}