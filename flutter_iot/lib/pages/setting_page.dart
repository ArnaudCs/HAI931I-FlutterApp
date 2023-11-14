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
    return Scaffold(
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
              child: Container(
                child: LongButton(
                  title: 'Wifi settings',
                  description: 'Get Wifi Name (Beta)',
                  imagePath: 'lib/icons/routeur.png',
                  onPressed: () {
                    // Appelez la méthode pour gérer la navigation vers WifiSettings
                    handleWifiSettingsPressed(context, 'WifiSettings');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
