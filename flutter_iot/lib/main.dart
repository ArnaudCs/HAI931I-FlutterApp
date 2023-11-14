import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/dependency_injection.dart';
import 'package:flutter_iot/pages/setting_page.dart';
import 'package:flutter_iot/pages/home_page.dart';
import 'package:flutter_iot/pages/weather_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pageIndex = 0;

  final List<Widget> _pageList = <Widget>[
    HomePage(),
    const WeatherPage(),
    const SettingPage(),
  ];

  final menus = [
    const Icon(Icons.home, color: Colors.white),
    const Icon(Icons.stacked_bar_chart_sharp, color: Colors.white),
    const Icon(Icons.settings, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          color: Colors.green.shade200,
          items: menus,
          animationCurve: Curves.easeInOutCubic,
          height: 60,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ),
        body: _pageList[_pageIndex],
      ),
    );
  }
}