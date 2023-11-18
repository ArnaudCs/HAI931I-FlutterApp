import 'package:flutter/material.dart';

class AppBarHome extends StatelessWidget {

  final prefix;
  final suffix;
  final icon;

  const AppBarHome({
    super.key,
    required this.prefix,
    required this.suffix,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                prefix,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
              Text(
                suffix,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(icon),
          ),
        ],
    );
  }
}