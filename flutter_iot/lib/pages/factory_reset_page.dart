import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/device_card_settings.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList(); 
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
                navBarPrefix: 'Factory  ',
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
                  padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
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

                      SizedBox(height: 5.0),

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

              SizedBox(height: 20.0),

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
                              icon: Icons.restart_alt,
                              iconColor: Colors.red.shade300,
                              onPressed: () {
                                final deviceId = device['deviceId'];
                                if (deviceId != null) {
                                  print('restoring device : $deviceId');
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