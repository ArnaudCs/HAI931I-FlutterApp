import 'package:flutter/material.dart';
import 'package:flutter_iot/dependency_injection.dart';
import 'package:flutter_iot/navigation/app_navigation.dart';
import 'package:flutter_iot/pages/app_intro_slides.dart';

void main() {
  runApp(const IntroSlides());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}