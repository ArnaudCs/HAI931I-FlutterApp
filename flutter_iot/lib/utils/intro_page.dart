import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Assurez-vous d'importer le package Lottie

class IntroPages extends StatelessWidget {

  final animationPath;
  final introText;
  final slideColor;

  const IntroPages({
    Key? key,
    required this.animationPath,
    required this.introText,
    required this.slideColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: slideColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Text(
              introText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Lottie.asset(
            animationPath,
            width: 400,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
