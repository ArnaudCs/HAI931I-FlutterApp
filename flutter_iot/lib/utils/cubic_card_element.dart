import 'package:flutter/material.dart';

class CubicCardElement extends StatelessWidget {

  final iconImagePath;
  final descriptionText;

  const CubicCardElement({
    super.key,
    required this.iconImagePath,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(21.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 20,
              )
            ],
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
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
    ]);
  }
}