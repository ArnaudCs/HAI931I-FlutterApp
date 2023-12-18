// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/animation_dialog.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:flutter_iot/utils/treshold_settings_card.dart';
import 'package:http/http.dart' as http;

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
  bool isSliderEnabled = false; // Nouvelle variable d'état pour activer/désactiver le slider


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

  void updateSliderState() {
    setState(() {
      isSliderEnabled = minTempTresh.text.isNotEmpty 
      && maxTempTresh.text.isNotEmpty 
      && minBrightnessTresh.text.isNotEmpty 
      && maxBrightnessTresh.text.isNotEmpty;
    });
    print(isSliderEnabled);
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
                      input1hint: 'Min temperature',
                      input2hint: 'Max temperature',
                      icon: Icons.thermostat_outlined,
                      controller1: minTempTresh,
                      controller2: maxTempTresh,
                      onUpdate: updateSliderState,
                    ),

                    const SizedBox(height: 20.0),

                    TrehsholdSettingsCard(
                      title: 'Brightness tresholds',
                      input1hint: 'Min brightness',
                      input2hint: 'Max brightness',
                      icon: Icons.sunny,
                      controller1: minBrightnessTresh,
                      controller2: maxBrightnessTresh,
                      onUpdate: updateSliderState,
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