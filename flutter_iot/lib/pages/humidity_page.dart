import 'package:flutter/material.dart';
import 'package:flutter_iot/models/humidity_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/data_gauge.dart';
import 'package:flutter_iot/utils/page_top_card.dart';

class HumidityPage extends StatefulWidget {
  const HumidityPage({super.key});

  @override
  State<HumidityPage> createState() => _HumidityPageState();
}

class _HumidityPageState extends State<HumidityPage> {

  bool _dataFetched = false;
  final _humidityService = SensorService('humidity'); 
  DateTime now = DateTime.now();
  Humidity? _humidity;

  _fetchHumidity() async {
    try{
      final humidity = await _humidityService.getSensorData();
      setState(() {
        _humidity = humidity;
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
      _fetchHumidity();
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
                title: 'Humidity',
                subTitle: 'About humidity',
                color1: Colors.blueAccent,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the humidity of your plant. The luminosity is measured in lux. The higher the value, the more light your plant receives',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              const Text(
                'Humidity',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _dataFetched
                  ? _humidity != null
                      ? DataGauge(
                          humidity: _humidity!.humidity.toInt().toDouble(),
                          minTreshold: 19,
                          maxTreshold: 78,
                        )
                      : const DataGauge(
                        humidity: 0.0,
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