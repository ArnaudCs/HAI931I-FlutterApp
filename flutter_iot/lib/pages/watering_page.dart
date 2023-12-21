import 'package:flutter/material.dart';
import 'package:flutter_iot/models/watering_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/page_top_card.dart';

class WateringPage extends StatefulWidget {
  const WateringPage({super.key});

  @override
  State<WateringPage> createState() => _WateringPageState();
}

class _WateringPageState extends State<WateringPage> {

  bool _dataFetched = false;
  final _wateringService = SensorService('watering', 'http://'); 
  DateTime now = DateTime.now();
  Watering? _timeBeforeWatering;

  _fetchWatering() async {
    try{
      final timeBeforeWatering = await _wateringService.getSensorData();
      setState(() {
        _timeBeforeWatering = timeBeforeWatering;
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
      _fetchWatering();
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
                title: 'Watering',
                subTitle: 'About watering',
                color1: Colors.blueAccent,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the watering of your plant, the watering is measured in percentage. The higher the value, the more water your plant has',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              const Text(
                'Watering',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Time before watering: ${_timeBeforeWatering?.timeBeforeWatering ?? '0'}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}