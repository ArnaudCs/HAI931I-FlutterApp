import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iot/models/brightness_model.dart';
import 'package:flutter_iot/models/temperature_model.dart';
import 'package:flutter_iot/models/weather_model.dart';
import 'package:flutter_iot/services/sensor_service.dart';
import 'package:flutter_iot/services/weather_service.dart';
import 'package:flutter_iot/utils/cubic_card_element.dart';
import 'package:flutter_iot/utils/card_home_element.dart';
import 'package:flutter_iot/utils/error_dialog.dart';
import 'package:flutter_iot/utils/long_button.dart';
import 'package:flutter_iot/utils/meteo_card.dart';
import 'package:go_router/go_router.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _controller;
  DateTime now = DateTime.now();
  Temperature? _temperature;
  late DateTime date = DateTime.now();
  BrightnessModel? _brightness;
  final _weatherService = WeatherService('9ac3a60a3ff2ad0c3ef4781a6514c4a0'); 
  Weather? _weather;
  late Timer _timer;
  late Timer _timerDevice;
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];
  List<String> actualUsedDevice = [];
  bool actualWifi = true;
  final NetworkInfo info = NetworkInfo();
  String? wifiName;
  bool addedDevices = true;

  Future<void> getWifiInfo() async {
    wifiName = await info.getWifiName();
    bool goodWifi = wifiName == '"${actualUsedDevice[2]}"';
    setState(() {
      actualWifi = goodWifi;
    });
  }

  late SensorService _brightnessService;
  late SensorService _temperatureService;

  Future<void> loadDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(deviceListKey);
    if (savedList != null) {
      deviceList = savedList.map<Map<String, String>>((jsonString) {
        final dynamicMap = jsonDecode(jsonString);
        return Map<String, String>.from(dynamicMap); // Convert dynamic to String
      }).toList();
    }

    addedDevices = deviceList.isNotEmpty;

    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    setState(() {});
  }

  Future<void> _initSensorsService() async {
    await loadDeviceList();
    _brightnessService = SensorService('brightness', actualUsedDevice.isNotEmpty ? actualUsedDevice[3] : '');
    _temperatureService = SensorService('temperature', actualUsedDevice.isNotEmpty ? actualUsedDevice[3] : '');
    _fetchBrightness();
    _fetchTemperature();
  }

  Future<void> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> _fetchBrightness() async {
    try{
      final brightness = await _brightnessService.getSensorData();
      setState(() {
        _brightness = brightness;
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> _fetchTemperature() async {
    try {
      final temperature = await _temperatureService.getSensorData();
      setState(() {
        _temperature = temperature;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList();
    _initSensorsService();
    _fetchWeather();
    getWifiInfo();  
    _controller = PageController(initialPage: 0);

    _timer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      getWifiInfo();
      _fetchWeather();
      _initSensorsService();
    });

    _timerDevice = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      loadDeviceList();
    });
  }

  void handleRouting(BuildContext context, String name) {
    context.goNamed(name);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showDeviceSelectionBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select Device',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: deviceList.length,
                itemBuilder: (context, index) {
                  final device = deviceList[index];
                  return ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.sensors, color: Colors.black),
                              const SizedBox(width: 10.0),
                              Text(device['deviceName'] ?? ''),
                            ],
                          ),

                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: actualUsedDevice.isNotEmpty && actualUsedDevice[0] == device['deviceId'] ? Colors.green : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: 
                            Icon(Icons.check, color: actualUsedDevice.isNotEmpty && actualUsedDevice[0] == device['deviceId'] ? Colors.white : Colors.grey)
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      setUsedDevice(device);
                      loadDeviceList();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 50.0)
          ],
        );
      },
    ).then((selectedDevice) {
      if (selectedDevice != null) {
        setState(() {});
      }
    });
  }

  Future<void> setUsedDevice(Map<String, String> deviceDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = deviceDetails['deviceId'] ?? '';
    prefs.setStringList(
      'actualUsedDevice',
      [deviceId, deviceDetails['deviceName'] ?? '', deviceDetails['deviceSSID'] ?? '', deviceDetails['deviceURL'] ?? ''],
    );
    print(prefs.getStringList('actualUsedDevice'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom],
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const AppBarHome(
          prefix: "Leaf",
          suffix: "Link",
          icon: Icons.qr_code,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDeviceSelectionBottomSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              actualUsedDevice.isNotEmpty && actualUsedDevice[0] != '' ? actualUsedDevice[1] : 'No device selected',
                              style: const TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                    
                            const Icon(Icons.arrow_drop_down, color: Colors.black)
                          ]
                        ,)
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              !actualWifi && addedDevices ? const ErrorDialog(title: 'Wrong Wi-Fi', content: 'You\'r on the wrong Wi-Fi for this device, please change it') : Container(),
              !addedDevices ? const ErrorDialog(title: 'No device added', content: 'You don\'t have any device, add one in the settings') : Container(),

              SizedBox(
                height: 170,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    WeatherCard(
                      city: _weather != null ? _weather!.cityName : 'Loading...',
                      condition: _weather != null ? _weather!.condition : 'Loading...',
                      temperature: _weather != null ? _weather!.temperature.toInt() : 'Loading...',
                    ),
                    HomeCardElement(
                      title: 'Temperature',
                      subtitle: _temperature != null ? "${_temperature!.temperature.toInt()} °C" : 'Loading...',
                      content: 'in °C',
                      icon: Icons.thermostat_outlined,
                      date: date,
                      color: Colors.grey[400],
                      imagePath: './assets/Images/humidity.jpg',
                      titleSize: 20.0,
                      contentSize: 35.0,
                      contentFontWeight: FontWeight.bold,
                      titleFontWeight : FontWeight.normal,
                    ),
                    HomeCardElement(
                      title: 'Brightness',
                      subtitle: _brightness != null ? "${_brightness!.brightness.toInt()} Lux" : 'Loading...',
                      content: 'Content',
                      icon: Icons.sunny,
                      date: date,
                      color: Colors.grey[400],
                      imagePath: './assets/Images/luminosity.jpg',
                      titleSize: 20.0,
                      contentSize: 35.0,
                      contentFontWeight: FontWeight.bold,
                      titleFontWeight : FontWeight.normal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.grey,
                  dotColor: Colors.grey,
                  dotHeight: 12.0,
                  dotWidth: 12.0,
                  expansionFactor: 3,
                ),
              ),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CubicCardElement(
                      iconImagePath: 'lib/icons/arrosage.png',
                      descriptionText: 'Watering',
                      onPressed: () {
                        handleRouting(context, 'WateringPage');
                      },
                    ),
                    CubicCardElement(
                      iconImagePath: 'lib/icons/capteurs.png',
                      descriptionText: 'Temperature',
                      onPressed: () {
                        handleRouting(context, 'TemperaturePage');
                      },
                    ),
                    CubicCardElement(
                      iconImagePath: 'lib/icons/luminosité.png',
                      descriptionText: 'Brightness',
                      onPressed: () {
                        handleRouting(context, 'BrightnessPage');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
                child: Column(
                  children: [
                    LongButton(
                      title: 'Weather',
                      description: 'Check the weather',
                      imagePath: 'lib/icons/météo.png',
                      onPressed: () {
                        handleRouting(context, 'WeatherPage');
                      },
                    ),
                    LongButton(
                      title: 'Alerts',
                      description: 'Check the alerts',
                      imagePath: 'lib/icons/alarme.png',
                      onPressed: () {
                        handleRouting(context, 'AlertPage');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
