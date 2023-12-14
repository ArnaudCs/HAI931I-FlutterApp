import 'package:flutter/material.dart';
import 'package:flutter_iot/models/temperature_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/data_gauge.dart';
import 'package:flutter_iot/utils/page_top_card.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {

  bool _dataFetched = false;
  final _temperatureService = SensorService('temperature'); 
  DateTime now = DateTime.now();
  Temperature? _temperature;

  _fetchTemperature() async {
    try{
      final temperature = await _temperatureService.getSensorData();
      setState(() {
        _temperature = temperature;
        _dataFetched = true;
      });
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_dataFetched) {
      _fetchTemperature();
    }
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
                title: 'Temperature',
                subTitle: 'About temperature',
                color1: Colors.blueAccent,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the temperature around your plant. The temperature is measured in degrees Celsius. The higher the value, the warmer your plant is',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              const Text(
                'Temperature',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _dataFetched
                  ? _temperature != null
                      ? DataGauge(
                          temperature: _temperature!.temperature.toInt().toDouble(),
                          minTreshold: 19,
                          maxTreshold: 78,
                        )
                      : const DataGauge(
                        temperature: 0.0,
                        minTreshold: 0.0,
                        maxTreshold: 15,
                      )
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}