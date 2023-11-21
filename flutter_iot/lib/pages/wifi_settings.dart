import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:flutter_iot/utils/text_fields.dart';
import 'package:http/http.dart' as http;
import 'package:slide_to_act/slide_to_act.dart';

class WifiSettings extends StatefulWidget {
  const WifiSettings({super.key});

  @override
  State<WifiSettings> createState() => _WifiSettingsState();
}

class _WifiSettingsState extends State<WifiSettings> {

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController securityCodeController = TextEditingController();
  bool isSliderEnabled = false; // Nouvelle variable d'état pour activer/désactiver le slider


  void sendWifiInfo() async {
    String ssid = ssidController.text;
    String password = passwordController.text;

    String baseUrl = 'http://192.168.4.1/configure';

    String encodedSsid = Uri.encodeComponent(ssid);
    String encodedPassword = Uri.encodeComponent(password);
    String apiUrl = '$baseUrl?ssid=$encodedSsid&password=$encodedPassword';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Data sent to ESP ... Waiting response');
      if (response.statusCode == 200) {
        print('Data sent successfully');
      } else {
        print('Error sending data. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during the request: $error');
    }

    // Clear the text fields
    ssidController.clear();
    passwordController.clear();
  }

  void updateSliderState() {
    setState(() {
      isSliderEnabled = ssidController.text.isNotEmpty && passwordController.text.isNotEmpty;
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
              const SimpleNavBar(
                prefix: 'Wifi ',
                suffix: 'Settings',
              ),

              const SizedBox(height: 30.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Ajoutez un padding horizontal
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connect your LeafLink',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Here you can send WI-FI informations to your ESP for the first connection, or if you need to reconnect it. Make sure to have the security code on your ESP before sending the informations.',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'Network name', 
                      obscureText: false, 
                      controller: ssidController,
                      textFieldIcon: const Icon(Icons.wifi), 
                      onChanged: (_) => updateSliderState(),
                    ),

                    const SizedBox(height: 10.0), 

                    CustomTextField(
                      hintText: 'Password', 
                      obscureText: true, 
                      controller: passwordController,
                      textFieldIcon: const Icon(Icons.lock), 
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
                      },
                      elevation: 0,
                      borderRadius: 16,
                      sliderButtonIcon: const Icon(Icons.send, color: Colors.white),
                      submittedIcon: Icon(Icons.check, color: Colors.green.shade600),
                      animationDuration: const Duration(milliseconds: 400),
                      enabled: isSliderEnabled,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}