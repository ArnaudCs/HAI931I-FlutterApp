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
        'pageName': '',
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
          child: Container(
            
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: buttons,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
