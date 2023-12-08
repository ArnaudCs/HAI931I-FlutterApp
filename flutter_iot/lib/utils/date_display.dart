import 'package:flutter/material.dart';

class DateDisplay extends StatelessWidget {
  const DateDisplay({super.key});

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Last update',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
        Text(
          '${now.hour}:${now.minute} - ${now.day}/${now.month}/${now.year}',
          style: const TextStyle(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}