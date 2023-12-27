import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/models/chart_data.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';
import 'package:flutter_iot/utils/error_dialog.dart';
import 'package:flutter_iot/utils/spline_chart_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  String deviceName = '';
  List<String> actualUsedDevice = [];
  List<ChartData> tempChartData = [];
  List<ChartData> brightChartData = [];
  bool _dataFetched = false;
  bool addedDevice = true;
  late Timer _timerDevice;

  Future<void> loadUsedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    deviceName = '${actualUsedDevice[0]} - ${actualUsedDevice[1]}';
    if (actualUsedDevice != null && actualUsedDevice.isNotEmpty && actualUsedDevice[0] == '') {
      addedDevice = false;
    }
    setState(() {});
    _initChartData();
  }

  Future<void> _initChartData() async {
    Map<DateTime, double> temperatureData = await fetchTemperatureData(deviceName);

    tempChartData = temperatureData.entries.map((entry) {
      return ChartData(date: entry.key, value: entry.value);
    }).toList();

    Map<DateTime, double> brightnessData = await fetchBrightnessData(deviceName);

    brightChartData = brightnessData.entries.map((entry) {
      return ChartData(date: entry.key, value: entry.value);
    }).toList();

    setState(() {});
  }

  Future<Map<DateTime, double>> fetchTemperatureData(String deviceName) async {
    Map<DateTime, double> temperatureData = {};
    try {
      String collectionPath = '$deviceName - Temp';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionPath).get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('date') && data.containsKey('temperature')) {
          DateTime date = data['date'].toDate();
          double temperature = data['temperature'].toDouble();
          temperatureData[date] = temperature;
        }
      }
      _dataFetched = true;
    } catch (error) {
      print('Error fetching temperature data: $error');
    }
    return temperatureData;
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

  @override
  void initState() {
    super.initState();
    loadUsedDevice();

    _timerDevice = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      loadUsedDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const AppBarHome(prefix: "My", suffix: "Stats", icon: Icons.pie_chart_sharp),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: 
            Column(
              children: [
                addedDevice ? 
                  Column(
                  children: [
                    const SizedBox(height: 20.0),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Here are your stats, you can see the sensors you have installed and the data they have collected.',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    _dataFetched ?
                      SplineChartCard(
                          chartTitle: 'Temperature history', 
                          absLabel: 'Date', 
                          ordLabel: 'Temperature', 
                          icon: Icons.thermostat_outlined,
                          chartData: tempChartData
                        ) : const CircularProgressIndicator(),

                    const SizedBox(height: 15.0),
                    _dataFetched ?
                      SplineChartCard(
                          chartTitle: 'Brightness history', 
                          absLabel: 'Date', 
                          ordLabel: 'Brightness', 
                          icon: Icons.lightbulb_outline,
                          chartData: brightChartData
                        ) : const CircularProgressIndicator(),
                  ],
                ) : const Padding(
                  padding: EdgeInsets.only(top : 20.0),
                  child: Center(child: ErrorDialog(title: 'No device added', content: 'You don\'t have any device, add one in the settings')),
                ),

                const SizedBox(height: 100.0),
              ],
            ),
          )
        )
      )
    );
  }
}