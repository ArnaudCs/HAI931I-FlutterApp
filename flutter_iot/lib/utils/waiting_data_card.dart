import 'package:flutter/material.dart';

class WaitingCard extends StatelessWidget {
  final title;
  final subtitle;
  final icon;

  const WaitingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Icon(
                icon,
                size: 30.0,
              )
            ],
          ),

          const SizedBox(height: 10.0),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          )
        ],
      )
    );
  }
}