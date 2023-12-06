import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/animation_dialog.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:flutter_iot/utils/text_fields.dart';
import 'package:http/http.dart' as http;

class TresholdSettings extends StatefulWidget {
  const TresholdSettings({super.key});

  @override
  State<TresholdSettings> createState() => _TresholdSettingsState();
}

class _TresholdSettingsState extends State<TresholdSettings> {

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController securityCodeController = TextEditingController();
  bool isSliderEnabled = false; // Nouvelle variable d'état pour activer/désactiver le slider


  void sendWifiInfo() async {
    String ssid = ssidController.text;
    String password = passwordController.text;

    String baseUrl = 'http://192.168.4.1/try';

    String encodedSsid = Uri.encodeComponent(ssid);
    String encodedPassword = Uri.encodeComponent(password);
    String apiUrl = '$baseUrl?ssid=$encodedSsid&password=$encodedPassword';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Data sent to ESP ... Waiting response');
      if (response.statusCode == 200) {
        print('Data sent successfully');
        showWifiDialog(
          "Success !", "Your ESP is now connected to your network. You can now go back to the home page and start using your LeafLink.", 
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
    }

    // Clear the text fields
    ssidController.clear();
    passwordController.clear();
    updateSliderState();
  }

  void updateSliderState() {
    setState(() {
      isSliderEnabled = ssidController.text.isNotEmpty && passwordController.text.isNotEmpty;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SimpleNavBar(
                prefix: 'Treshold ',
                suffix: 'Settings',
              ),

              const SizedBox(height: 30.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Ajoutez un padding horizontal
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Set your tresholds',
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
                        'Here you can set the tresholds for your plant. If the humidity or brightness goes above or below the treshold, you will receive an alert.',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'Network name', 
                      obscureText: false, 
                      controller: ssidController,
                      textFieldIcon: const Icon(Icons.wifi), 
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateSliderState(),
                    ),

                    const SizedBox(height: 10.0), 

                    CustomTextField(
                      hintText: 'Max humdiity', 
                      obscureText: false, 
                      controller: passwordController,
                      textFieldIcon: const Icon(Icons.lock), 
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateSliderState(),
                    ),

                    const SizedBox(height: 10.0), 

                    CustomTextField(
                      hintText: 'Network name', 
                      obscureText: false, 
                      controller: ssidController,
                      textFieldIcon: const Icon(Icons.wifi), 
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateSliderState(),
                    ),

                    const SizedBox(height: 10.0), 

                    CustomTextField(
                      hintText: 'Max humdiity', 
                      obscureText: false, 
                      controller: passwordController,
                      textFieldIcon: const Icon(Icons.lock), 
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateSliderState(),
                    ),

                    const SizedBox(height: 10.0), 

                    CustomTextField(
                      hintText: 'Network name', 
                      obscureText: false, 
                      controller: ssidController,
                      textFieldIcon: const Icon(Icons.wifi), 
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateSliderState(),
                    ),

                    const SizedBox(height: 10.0), 

                    CustomTextField(
                      hintText: 'Max humdiity', 
                      obscureText: false, 
                      controller: passwordController,
                      textFieldIcon: const Icon(Icons.lock), 
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateSliderState(),
                    ),

                    

                    const SizedBox(height: 20.0),
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