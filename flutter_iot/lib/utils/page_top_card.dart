import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';

class PageTopCard extends StatelessWidget {
  final prefixTitle;
  final title;
  final subTitle;
  final color1;
  final color2;
  final text;
  final cornerLeft;
  final cornerRight;

  const PageTopCard({
    super.key,
    required this.prefixTitle,
    required this.title,
    required this.subTitle,
    required this.color1,
    required this.color2,
    required this.text,
    required this.cornerLeft,
    required this.cornerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            color1,
            color2,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(cornerLeft),
          bottomRight: Radius.circular(cornerRight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SimpleNavBar(
            prefix: prefixTitle,
            suffix: title,
          ),
    
          const SizedBox(height: 30.0),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0), // Ajoutez un padding horizontal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
    
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}