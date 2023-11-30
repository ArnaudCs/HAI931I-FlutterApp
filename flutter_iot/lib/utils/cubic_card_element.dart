import 'package:flutter/material.dart';

class CubicCardElement extends StatelessWidget {

  final String iconImagePath;
  final String descriptionText;
  final VoidCallback? onPressed;

  const CubicCardElement({
    super.key,
    required this.iconImagePath,
    required this.descriptionText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(21.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  offset: const Offset(5, 5),
                  blurRadius: 15,
                  spreadRadius: 1.0,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5, -5),
                  blurRadius: 15,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(iconImagePath),
              )
            ),
          ),
    
          const SizedBox(height: 8.0),
    
          Text(
            descriptionText,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          )
      ]),
    );
  }
}