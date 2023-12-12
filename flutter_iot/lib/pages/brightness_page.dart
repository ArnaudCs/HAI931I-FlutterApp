import 'package:flutter/material.dart';
import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/brightness_gauge.dart';
import 'package:flutter_iot/utils/date_display.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:flutter_iot/utils/icon_button.dart';

class BrightnessPage extends StatefulWidget {
  const BrightnessPage({super.key});

  @override
  State<BrightnessPage> createState() => _BrightnessPageState();
}

class _BrightnessPageState extends State<BrightnessPage> {

  bool _dataFetched = false;
  final _brightnessService = SensorService('brightness'); 
  DateTime now = DateTime.now();
  BrightnessModel? _brightness;

  _fetchBrightness() async {
    try{
      final brightness = await _brightnessService.getSensorData();
      setState(() {
        _brightness = brightness;
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
      _fetchBrightness();
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
                title: 'Brightness',
                subTitle: 'About brightness',
                color1: Colors.blue.shade200,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the brightness around your plant. The brightness is measured in lux. The higher the value, the more light your plant receives',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
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
                            ?BrightnessGauge(
                              brightness: _brightness?.brightness ?? 0.0, 
                              minMarker: 10.0, 
                              maxMarker: 78.0,
                            )
                            : const BrightnessGauge(
                                brightness: 1.0, 
                                minMarker: 0.0, 
                                maxMarker: 100.0,
                              )
                        : const LinearProgressIndicator(),

                      const SizedBox(height: 10.0),

                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: Text(
                            '${_brightness?.brightness ?? 0.0} Lux',
                            style: const TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      DateDisplay()
                      
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: SimpleIconButton(
                  buttonIcon: Icons.refresh,
                  buttonText: 'Refresh'
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}