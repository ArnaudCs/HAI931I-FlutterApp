import 'package:flutter/material.dart';
import 'package:flutter_iot/models/color_model.dart';
import 'package:flutter_iot/utils/color_picker.dart';
import 'package:flutter_iot/utils/error_dialog.dart';
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
  bool addedDevice = true;
  ColorData? selectedColor;

  Future<void> loadDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    if (actualUsedDevice != null && actualUsedDevice.isNotEmpty && actualUsedDevice[0] == '') {
      addedDevice = false;
    }
  }


  void sendLedCommand() async {
    String baseUrl = 'http://${actualUsedDevice[3]}/led?red=off&green=off&rgb=${ isOn ? 'on' : 'off' }&color=magenta';
    try {
      final response = await http.post(Uri.parse(baseUrl));
    } catch (error) {
      print('Error during the request: $error');
    }
  }

  void changeLedColor(String color) async {
    String color = selectedColor!.name.toLowerCase();
    String baseUrl = 'http://${actualUsedDevice[3]}/led?red=off&green=off&rgb=on&color=${color}';
    try {
      final response = await http.post(Uri.parse(baseUrl));
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

    final List<ColorData> colorList = [
      ColorData(name: 'Magenta', color: Color.fromRGBO(255, 0, 255, 1)),
      ColorData(name: 'Cyan', color: Color.fromRGBO(0, 255, 255, 1)),
      ColorData(name: 'Blue', color: Colors.blue),
      ColorData(name: 'Red', color: Colors.red),
      ColorData(name: 'Green', color: Colors.green),
      ColorData(name: 'Yellow', color: Colors.yellow),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
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

              addedDevice ?
                Column(
                  children: [
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
                        child: Column(
                          children: [

                            SizedBox(height: 20.0),

                            const Text(
                              'Change the LED color',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    
                            const SizedBox(height: 20.0),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (final colorData in colorList)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedColor = colorData;
                                        isOn = true;
                                      });
                                      changeLedColor(colorData.name);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              colorData.name,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Container(
                                              width: 40,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: colorData.color,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                        ]),
                      ),
                    )
                  ],
                ) : const ErrorDialog(title: 'No device added', content: 'You don\'t have any device, add one in the settings'),

              const SizedBox(height: 150.0),
            ]
          )
        )
      )
    );
  }
}