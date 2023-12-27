import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/animation_dialog.dart';
import 'package:flutter_iot/utils/device_card_settings.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FactoryResetPage extends StatefulWidget {
  const FactoryResetPage({super.key});

  @override
  State<FactoryResetPage> createState() => _FactoryResetPageState();
}

class _FactoryResetPageState extends State<FactoryResetPage> {
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];

  Future<void> loadDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(deviceListKey);
    if (savedList != null) {
      deviceList = savedList.map<Map<String, String>>((jsonString) {
        final dynamicMap = jsonDecode(jsonString);
        return Map<String, String>.from(dynamicMap); // Convert dynamic to String
      }).toList();
    }

    print(deviceList);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList(); 
  }

  void showWifiDialog(title, content, buttonText, animPath, colorButton) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimationDialog(
          title: title, 
          content: content, 
          buttonText: buttonText, 
          animPath: animPath,
          colorButton: colorButton,
        );
      },
    );
  }

  void resetById(String deviceId) async {
    Map<String, String>? targetDevice;
    for (Map<String, String> device in deviceList) {
      if (device['deviceId'] == deviceId) {
        targetDevice = device;
        break;
      }
    }

    if (targetDevice == null) {
      print('Device not found for ID: $deviceId');
      return;
    }

    String deviceUrl = targetDevice['deviceURL'] ?? '';
    String apiUrl = 'http://$deviceUrl/reset';

    try {
      final response = await http.post(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        showWifiDialog(
          "Yeahh !", "Your device has been reset to factory settings.", 
          "Ok, next !", 
          'assets/anim_success.json',
          Colors.green[300],
        ); 
      } else {
        showWifiDialog(
          "Connection Timeout", 
          "The connection to the ESP timed out. Please check your Wi-Fi connection and try again.", 
          "OK, i'll check !", 
          'assets/anim_error.json',
          Colors.red[300],
        );
        print('Error sending reset request. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the reset request: $error');
    }
    setState(() {});
  }

  void showConfirmDeleteDialog(String deviceId, String deviceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          title: const Text(
            'Confirm reset',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Are you sure you want to reset this device ? (Device $deviceName)'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                resetById(deviceId);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingTopCard(
                navBarPrefix: 'Factory ',
                navBarSuffix: 'Reset',
                title: 'Reset devices',
                subtitle: 'Here you can reset your devices to factory settings',
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Warning !',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.warning,
                            color: Colors.white,
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0),

                      Text(
                        'This action is irreversible, be careful resetting your devices, you will keep your data but you will loose your thresholds',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
              
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Your connected devices',
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),

                      const Divider(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: deviceList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final device = deviceList[index];
                            return DeviceSettingsCard(
                              title: device['deviceName'] ?? '',
                              subTitle: 'Added on ${device['deviceAddDate']}' ?? '',
                              ip: device['deviceURL'] ?? '',
                              icon: Icons.restart_alt,
                              iconColor: Colors.red.shade300,
                              onPressed: () {
                                final deviceId = device['deviceId'];
                                if (deviceId != null) {
                                  showConfirmDeleteDialog(deviceId, device['deviceName'] ?? '');
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ),
              ),

              const SizedBox(height: 100.0),
            ]
          )
        )
      )
    );
  }
}