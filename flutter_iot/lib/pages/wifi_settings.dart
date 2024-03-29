import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/animation_dialog.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:flutter_iot/utils/text_fields.dart';
import 'package:flutter_iot/utils/wifi_information_module.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WifiSettings extends StatefulWidget {
  const WifiSettings({super.key});

  @override
  State<WifiSettings> createState() => _WifiSettingsState();
}

class _WifiSettingsState extends State<WifiSettings> {

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController deviceNameController = TextEditingController();
  bool isSliderEnabled = false; // Nouvelle variable d'état pour activer/désactiver le slider
  bool wifiSetup = false;
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];
  DateTime now = DateTime.now();

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

  Future<void> addDeviceToList(String deviceName, String deviceAddDate, String deviceSSID, String deviceId, String deviceURL) async {
    final newDevice = {'deviceId': deviceId, 'deviceName': deviceName, 'deviceAddDate': deviceAddDate, 'deviceSSID': deviceSSID, 'deviceURL': deviceURL};
    deviceList.add(newDevice);
    await saveDeviceList();
    await setUsedDevice(newDevice);
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

  void initializeWifiSetup() async {
    wifiSetup = await isWifiSetup();
    print('Setup wifi bool : $wifiSetup');
    setState(() {});
  }

  void initState() {
    super.initState();
    initializeWifiSetup();
    loadDeviceList();
  }

  void saveWifiName(String wifiName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('setupWifi', wifiName);
    setState(() {
      wifiSetup = true;
    });
    print('Setup wifi : save ${prefs.getString('setupWifi')}');
  }

  void sendWifiInfo() async {
    String ssid = ssidController.text;
    String password = passwordController.text;
    String deviceName = deviceNameController.text;

    String baseUrl = 'http://192.168.4.1/configure';

    String encodedSsid = Uri.encodeComponent(ssid);
    String encodedPassword = Uri.encodeComponent(password);
    String apiUrl = '$baseUrl?ssid=$encodedSsid&password=$encodedPassword';

    try {
      final response = await http.post(Uri.parse(apiUrl));
      print('Data sent to ESP ... Waiting response');
      if (response.statusCode == 200) {
        print('Data sent successfully');
        saveWifiName(ssid);
        String uniqueId = now.millisecondsSinceEpoch.toString();
        addDeviceToList(deviceName, now.toString(), ssid, uniqueId, response.body);
        showWifiDialog(
          "Success !", "Your ESP is now connected to your network. You can now go into Settings -> Manage Device to manage or add devices to your app. You can add a new device by scanning the QR code provided on the screen", 
          "Cool, next !", 
          'assets/anim_success.json',
          Colors.green[300],
        ); 
      } else {
        print('Error sending data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        showWifiDialog(
          "Argghhh !", 
          "Your LeafLink is having trouble connecting to your WI-FI, try restarting it or check your informations", 
          "OK, i'll do it !", 
          'assets/anim_error.json',
          Colors.red[300],
        ); 
      }
    } catch (error) {
      print('Error during the request: $error');
      saveWifiName(ssid);
      // Vérifie si l'erreur est due à un dépassement du délai
      if (error is SocketException && error.message.contains('timed out')) {
        showWifiDialog(
          "Connection Timeout", 
          "The connection to the ESP timed out. Please check your Wi-Fi connection and try again. The SSID sent was $ssid", 
          "OK, i'll check !", 
          'assets/anim_error.json',
          Colors.red[300],
        );
      }
    }

    // Clear the text fields
    ssidController.clear();
    passwordController.clear();

    updateSliderState();
  }

  void updateSliderState() {
    setState(() {
      isSliderEnabled = ssidController.text.isNotEmpty && passwordController.text.isNotEmpty && deviceNameController.text.isNotEmpty;
    });
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

  Future<bool> isWifiSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wifiName = prefs.getString('setupWifi');
    return wifiName != null && wifiName != '';
  }

  void resetWifiSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('setupWifi', '');
    setState(() {
      wifiSetup = false;
    });
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
                navBarPrefix: 'Wi-Fi ',
                navBarSuffix: 'Settings',
                title: 'Connect your LeafLink',
                subtitle:
                    'Here you can send WI-FI informations to your ESP for the first connection, or if you need to reconnect it. Make sure to have the security code on your ESP before sending the informations.',
              ),
              const SizedBox(height: 20.0),
              const WifiInformationModule(),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: wifiSetup
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Wi-Fi is already setup',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Set a new one ? ',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    resetWifiSetup();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Set new',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          CustomTextField(
                            hintText: 'Network name',
                            obscureText: false,
                            controller: ssidController,
                            textFieldIcon: const Icon(Icons.wifi),
                            keyboardType: TextInputType.text,
                            onChanged: (_) => updateSliderState(),
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            hintText: 'Password',
                            obscureText: true,
                            controller: passwordController,
                            textFieldIcon: const Icon(Icons.lock),
                            keyboardType: TextInputType.text,
                            onChanged: (_) => updateSliderState(),
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextField(
                            hintText: 'Device Name',
                            obscureText: false,
                            controller: deviceNameController,
                            textFieldIcon: const Icon(Icons.devices_rounded),
                            keyboardType: TextInputType.text,
                            onChanged: (_) => updateSliderState(),
                          ),
                          const SizedBox(height: 20.0),
                          SlideAction(
                            text: 'Slide to send',
                            textStyle: TextStyle(
                              color: isSliderEnabled ? Colors.green.shade200 : Colors.grey.shade300,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                            innerColor: isSliderEnabled ? Colors.green.shade200 : Colors.grey.shade300,
                            outerColor: Colors.grey.shade200,
                            onSubmit: () {
                              sendWifiInfo();
                              return null;
                            },
                            elevation: 0,
                            borderRadius: 16,
                            sliderButtonIcon: const Icon(Icons.send, color: Colors.white),
                            submittedIcon: Icon(Icons.check, color: Colors.green.shade600),
                            animationDuration: const Duration(milliseconds: 400),
                            enabled: isSliderEnabled,
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 150)
            ],
          ),
        ),
      ),
    );
  }
}