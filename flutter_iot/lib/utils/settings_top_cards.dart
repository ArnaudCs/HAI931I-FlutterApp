import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';

class SettingTopCard extends StatelessWidget {
  final navBarPrefix;
  final navBarSuffix;
  final title;
  final subtitle;

  const SettingTopCard({
    super.key,
    required this.navBarPrefix,
    required this.navBarSuffix,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SimpleNavBar(
          prefix: navBarPrefix,
          suffix: navBarSuffix,
        ),

        const SizedBox(height: 30.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0), // Ajoutez un padding horizontal
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}