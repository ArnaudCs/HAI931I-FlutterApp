import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/welcome_screen.dart';

class IntroSlides extends StatelessWidget {
  const IntroSlides({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeSlides(),
      debugShowCheckedModeBanner: false,
    );
  }
}