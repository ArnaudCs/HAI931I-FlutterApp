import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/device_card_settings.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceManagerPage extends StatefulWidget {
  const DeviceManagerPage({super.key});

  @override
  State<DeviceManagerPage> createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<DeviceManagerPage> {
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];
  late Timer _timerDevice;

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

  Future<void> saveDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = deviceList.map((device) => jsonEncode(device)).toList();
    prefs.setStringList(deviceListKey, jsonStringList);
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
  void initState() {
    super.initState();
    loadDeviceList(); 

    _timerDevice = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await loadDeviceList();
    });
  }

  Future<void> removeDeviceById(String deviceId) async {
    deviceList.removeWhere((device) => device['deviceId'] == deviceId);
    await saveDeviceList();
    await loadDeviceList();
    if (deviceList.isNotEmpty) {
      await setUsedDevice(deviceList[0]);
    } else {
      await setUsedDevice({});
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timerDevice.cancel();
    super.dispose();
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
                navBarPrefix: 'My ',
                navBarSuffix: 'Devices',
                title: 'Manage devices',
                subtitle: 'Here you can manage your connected devices, and disconnect them if needed.',
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
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                                onPressed: () {
                                  context.goNamed('AddDevicePage');
                                },
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
                              icon: Icons.delete,
                              iconColor: Colors.red.shade300,
                              onPressed: () {
                                final deviceId = device['deviceId'];
                                if (deviceId != null) {
                                  removeDeviceById(deviceId);
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