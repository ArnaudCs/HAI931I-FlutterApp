import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/device_card_settings.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceManagerPage extends StatefulWidget {
  const DeviceManagerPage({super.key});

  @override
  State<DeviceManagerPage> createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<DeviceManagerPage> {
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

  Future<void> saveDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = deviceList.map((device) => jsonEncode(device)).toList();
    prefs.setStringList(deviceListKey, jsonStringList);
  }

  Future<void> addDeviceToList(String deviceName, String deviceAddDate, String deviceSSID, String deviceId) async {
    final newDevice = {'deviceId': deviceId ,'deviceName': deviceName, 'deviceAddDate': deviceAddDate, 'deviceSSID': deviceSSID};
    deviceList.add(newDevice);
    await saveDeviceList();
    await setUsedDevice(deviceId);
    setState(() {});
  }

  Future<void> setUsedDevice(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('actualUsedDevice', deviceId);
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList(); 
  }

  Future<void> removeDeviceById(String deviceId) async {
    deviceList.removeWhere((device) => device['deviceId'] == deviceId);
    await saveDeviceList();
    await loadDeviceList();
    if (deviceList.isNotEmpty) {
      await setUsedDevice(deviceList[0]?['deviceId'] ?? '');
    } else {
      await setUsedDevice('');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                                  DateTime now = DateTime.now();
                                  String uniqueId = now.millisecondsSinceEpoch.toString();
                                  addDeviceToList(uniqueId, '2021-06-12', 'WifiPrivate', uniqueId);
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
              )
            ]
          )
        )
      )
    );
  }
}