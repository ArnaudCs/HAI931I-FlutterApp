import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';
import 'package:flutter_iot/utils/simple_button.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';

class WifiSettings extends StatelessWidget {
  const WifiSettings({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SimpleNavBar(
                  prefix: 'Wifi ',
                  suffix: 'Settings',
                ),
            ]),
        ),
      ),
    );
  }
}