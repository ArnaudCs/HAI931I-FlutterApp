import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:http/http.dart' as http;

class LuminosityPage extends StatefulWidget {
  const LuminosityPage({super.key});

  @override
  State<LuminosityPage> createState() => _LuminosityPageState();
}

class _LuminosityPageState extends State<LuminosityPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageTopCard(
                prefixTitle: '',
                title: 'Luminosity',
                subTitle: 'About luminosity',
                color1: Colors.blue.shade200,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the luminosity of your plant. The luminosity is measured in lux. The higher the value, the more light your plant receives',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              const Text(
                'Luminosity',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}