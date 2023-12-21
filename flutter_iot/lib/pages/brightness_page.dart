import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/utils/brightness_gauge.dart';
import 'package:flutter_iot/utils/date_display.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:flutter_iot/utils/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String deviceName = '';

  Future<void> loadUsedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    deviceName = '${actualUsedDevice[0]} - ${actualUsedDevice[1]}';
    setState(() {});
  }

  Future<void> _fetchBrightness() async {
    try{
      await _initBrightnessService();
      final brightness = await _brightnessService.getSensorData();
      await _updateFirestore(brightness);
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
    _fetchBrightness();
  }

  Future<void> _initBrightnessService() async {
    await loadUsedDevice();
    _brightnessService = SensorService('brightness', actualUsedDevice.isNotEmpty ? actualUsedDevice[3] : '');
  }

  Future<void> _updateFirestore(BrightnessModel brightnessModel) async {
    CollectionReference temperatureCollection = _firestore.collection('$deviceName - Bright');
    DateTime now = DateTime.now();
    String sensorId = actualUsedDevice.isNotEmpty ? deviceName : '';
    Map<String, dynamic> data = {
      'sensorId': sensorId,
      'temperature': brightnessModel.brightness,
      'date': DateTime.now(),
    };

    await temperatureCollection.doc(now.toString()).set(data, SetOptions(merge: true));
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
                child: Padding(
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
                            ?BrightnessGauge(
                              brightness: _brightness?.brightness ?? 0.0, 
                              minMarker: 1200.0, 
                              maxMarker: 7456.0,
                            )
                            : const BrightnessGauge(
                                brightness: 1.0, 
                                minMarker: 1000.0, 
                                maxMarker: 9000.0,
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
                            '${_brightness?.brightness.toDouble() ?? 0.0} Lux',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}