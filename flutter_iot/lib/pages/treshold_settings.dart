// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iot/models/threshold_model.dart';
import 'package:flutter_iot/utils/animation_dialog.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:flutter_iot/utils/treshold_settings_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TresholdSettings extends StatefulWidget {
  const TresholdSettings({super.key});

  @override
  State<TresholdSettings> createState() => _TresholdSettingsState();
}

class _TresholdSettingsState extends State<TresholdSettings> {

  TextEditingController minTempTresh = TextEditingController();
  TextEditingController maxTempTresh = TextEditingController();
  TextEditingController minBrightnessTresh = TextEditingController();
  TextEditingController maxBrightnessTresh = TextEditingController();
  TextEditingController waterTimeTresh = TextEditingController();
  bool isSliderEnabled = false; // Nouvelle variable d'état pour activer/désactiver le slider
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];
  List<String> actualUsedDevice = [];
  late Thresholds thresholds;
  bool isModified = false;

  Future<void> loadDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(deviceListKey);
    if (savedList != null) {
      deviceList = savedList.map<Map<String, String>>((jsonString) {
        final dynamicMap = jsonDecode(jsonString);
        return Map<String, String>.from(dynamicMap); // Convert dynamic to String
      }).toList();
    }

    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    print('actualUsedDevice: $actualUsedDevice');

    String baseUrl = 'http://${actualUsedDevice[3]}';
    String apiUrl = '$baseUrl/threshold';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        thresholds = Thresholds.fromJson(jsonResponse);
        minTempTresh.text = thresholds.minTemp.toString();
        maxTempTresh.text = thresholds.maxTemp.toString();
        minBrightnessTresh.text = thresholds.minBrightness.toString();
        maxBrightnessTresh.text = thresholds.maxBrightness.toString();
        waterTimeTresh.text = thresholds.waterTime.toString();

      // Mettre à jour l'état du slider après avoir rempli les contrôleurs
      updateSliderState();
      } else {
        print('Error receiving data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the request: $error');
    }
    setState(() {});
  }

  void getTresholds() async {
    
  }

  void sendWifiInfo() async {
    String minHumidity = minTempTresh.text;
    String maxHumidity = maxTempTresh.text;
    String minBrightness = minBrightnessTresh.text;
    String maxBrightness = maxBrightnessTresh.text;

    String baseUrl = 'http://192.168.4.1/try';

    String encodedMinTemperature = Uri.encodeComponent(minHumidity);
    String encodedMaxTemperature = Uri.encodeComponent(maxHumidity);
    String encodedMinBrightness = Uri.encodeComponent(minBrightness);
    String encodedMaxBrightness = Uri.encodeComponent(maxBrightness);

    String apiUrl = '$baseUrl?ssid=$encodedMinTemperature&password=$encodedMaxTemperature'; // à modifier

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Data sent to ESP ... Waiting response');
      if (response.statusCode == 200) {
        print('Data sent successfully');
        showWifiDialog(
          "Success !", "Your new tresholds have been sent to your LeafLink", 
          "Cool, next !", 
          'assets/anim_success.json',
          Colors.green[300],
        ); 
      } else {
        print('Error sending data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        showWifiDialog(
          "Argghhh !", 
          "Your LeafLink is having trouble receiving your new tresholds. Please try again.", 
          "OK, i'll do it !", 
          'assets/anim_error.json',
          Colors.red[300],
        ); 
      }
    } catch (error) {
      print('Error during the request: $error');
    }

    // Clear the text fields
    minTempTresh.clear();
    maxTempTresh.clear();
    minBrightnessTresh.clear();
    maxBrightnessTresh.clear();
    updateSliderState();
  }

  void verifyModified() {
    if (minTempTresh.text != thresholds.minTemp.toString() 
    || maxTempTresh.text != thresholds.maxTemp.toString() 
    || minBrightnessTresh.text != thresholds.minBrightness.toString()
    || maxBrightnessTresh.text != thresholds.maxBrightness.toString()
    || waterTimeTresh.text != thresholds.waterTime.toString()) {
      isModified = true;
    } else {
      isModified = false;
    }
  }

  void updateSliderState() {
    verifyModified();
    setState(() {
      isSliderEnabled = minTempTresh.text.isNotEmpty 
      && maxTempTresh.text.isNotEmpty 
      && minBrightnessTresh.text.isNotEmpty 
      && maxBrightnessTresh.text.isNotEmpty 
      && waterTimeTresh.text.isNotEmpty
      && isModified;
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

  @override
  void initState() {
    super.initState();
    loadDeviceList();
    getTresholds();
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
                navBarSuffix: 'Tresholds',
                title: 'Set your thresholds',
                subtitle: 'Here you can set the tresholds for your plant. If the humidity or brightness goes above or below the treshold, you will receive an alert.',
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    
                    TrehsholdSettingsCard(
                      title: 'Temperature tresholds',
                      subtitle: 'Set the min and max temperature for your plant, Min and max temperature are in °C, from -50 to 100',
                      input1hint: 'Min temperature',
                      input2hint: 'Max temperature',
                      icon: Icons.thermostat_outlined,
                      isSingle: false,
                      controller1: minTempTresh,
                      controller2: maxTempTresh,
                      onUpdate: updateSliderState,
                    ),

                    const SizedBox(height: 20.0),

                    TrehsholdSettingsCard(
                      title: 'Brightness tresholds',
                      subtitle: 'Set the min and max brightness for your plant, Min and max brightness are in lux, from 0 to 10000',
                      input1hint: 'Min brightness',
                      input2hint: 'Max brightness',
                      icon: Icons.sunny,
                      isSingle: false,
                      controller1: minBrightnessTresh,
                      controller2: maxBrightnessTresh,
                      onUpdate: updateSliderState,
                    ),

                    const SizedBox(height: 20.0),

                    TrehsholdSettingsCard(
                      title: 'Water tresholds',
                      subtitle: 'Set the min and max water time for your plant, Min and max water time are in seconds, from 0 to 10000',
                      input1hint: 'Water Time',
                      input2hint: '',
                      icon: Icons.water_drop,
                      isSingle: true,
                      controller1: waterTimeTresh,
                      controller2: waterTimeTresh,
                      onUpdate: updateSliderState,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SlideAction(
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
              ),

              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}