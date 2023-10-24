import 'package:flutter/material.dart';
import 'package:flutter_iot/pages/weather_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: WeatherPage(),
      ),
    );
  }
}