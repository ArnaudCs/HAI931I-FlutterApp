import 'package:flutter/material.dart';
import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/dev_card.dart';
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
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromRGBO(254, 96, 110, 1),
                                Color.fromRGBO(104, 213, 253, 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              DevCard(
                data: _brightness?.brightness.toString() ?? "No data",
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