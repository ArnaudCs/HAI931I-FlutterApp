import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LedControlSettings extends StatefulWidget {
  const LedControlSettings({super.key});

  @override
  State<LedControlSettings> createState() => _LedControlSettingsState();
}

class _LedControlSettingsState extends State<LedControlSettings> {
  bool isOn = false;
  List<String> actualUsedDevice = [];

  Future<void> loadDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    print('actualUsedDevice: $actualUsedDevice');
  }


  void sendLedCommand() async {
    String baseUrl = 'http://${actualUsedDevice[3]}/led?red=off&green=${ isOn ? 'on' : 'off' }&rgb=${ isOn ? 'on' : 'off' }&color=magenta';
    print('baseUrl: $baseUrl');

    try {
      final response = await http.post(Uri.parse(baseUrl));
      print('LED ON/OFF');
    } catch (error) {
      print('Error during the request: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SettingTopCard(
                navBarPrefix: 'My ',
                navBarSuffix: 'LED',
                title: 'Control your LED',
                subtitle: 'Here you can control your LED colors and state, you can also turn it on and off.',
              ),

              const SizedBox(height: 40.0),

              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  setState(() {
                    isOn = !isOn;
                    sendLedCommand();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                        color: isOn ? Colors.green.shade200 : Colors.red.shade200,
                        offset: const Offset(5, 5),
                        blurRadius: 25,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: isOn ? Colors.green.shade200 : Colors.red.shade200,
                        offset: Offset(-5, -5),
                        blurRadius: 25,
                        spreadRadius: 1.0,
                      ) 
                    ],
                  ),
                  child: Icon(Icons.power_settings_new, color: isOn ? Colors.green : Colors.red),
                ),
              ),

              const SizedBox(height: 30.0),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Column(
                    children: [

                      SizedBox(height: 20.0),

                      Text(
                        'Change the LED color',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              
                      SizedBox(height: 20.0),
                  ]),
                ),
              )
            ]
          )
        )
      )
    );
  }
}