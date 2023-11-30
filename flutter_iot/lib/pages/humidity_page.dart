import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/page_top_card.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:http/http.dart' as http;

class HumidityPage extends StatefulWidget {
  const HumidityPage({super.key});

  @override
  State<HumidityPage> createState() => _HumidityPageState();
}

class _HumidityPageState extends State<HumidityPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageTopCard(
                prefixTitle: '',
                title: 'Humidity',
                subTitle: 'About humidity',
                color1: Colors.blueAccent,
                color2: Colors.green.shade200,
                text: 'Here you can monitor the humidity of your plant. The luminosity is measured in lux. The higher the value, the more light your plant receives',
                cornerLeft: 30.0,
                cornerRight: 30.0,
              ),
              
              const SizedBox(height: 20),

              const Text(
                'Humidity',
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