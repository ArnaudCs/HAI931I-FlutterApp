import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';
import 'package:flutter_iot/utils/long_button.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  void handleWifiSettingsPressed(BuildContext context, String name) {
    context.goNamed(name);
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> buttonData = [
      {
        'title': 'LED Control',
        'description': 'Control LED state and colors',
        'imagePath': 'lib/icons/led.png',
        'pageName': 'LedControlSettings',
      },
      {
        'title': 'Wifi settings',
        'description': 'Get Wifi Name (Beta)',
        'imagePath': 'lib/icons/routeur.png',
        'pageName': 'WifiSettings',
      },
      {
        'title': 'Treshold settings',
        'description': 'Change sensor thresholds',
        'imagePath': 'lib/icons/bornes.png',
        'pageName': 'TresholdSettings',
      },
      {
        'title': 'Manage devices',
        'description': 'Manage connected devices',
        'imagePath': 'lib/icons/leaflink.png',
        'pageName': 'DeviceManagerSettings',
      },
      {
        'title': 'Factory reset',
        'description': 'Reset to factory settings',
        'imagePath': 'lib/icons/reset.png',
        'pageName': 'FactoryResetSettings',
      },
    ];

    List<Widget> buttons = [];

    for (Map<String, dynamic> data in buttonData) {
      buttons.add(
        LongButton(
          title: data['title'],
          description: data['description'],
          imagePath: data['imagePath'],
          onPressed: () {
            // Appelez la méthode pour gérer la navigation vers WifiSettings
            handleWifiSettingsPressed(context, data['pageName']);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const AppBarHome(prefix: "My", suffix: "Settings", icon: Icons.settings),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      // Le reste de votre code reste inchangé
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: buttons,
                  ),
                ),
              ),

              const SizedBox(height: 5.0),

              Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child : Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
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
