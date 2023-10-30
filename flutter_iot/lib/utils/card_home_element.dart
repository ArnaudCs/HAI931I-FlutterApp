import 'package:flutter/material.dart';

class HomeCardElement extends StatelessWidget {

  final title;
  final subtitle;
  final content;
  final icon;
  final color;
  const HomeCardElement({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
                const Icon(
                  Icons.account_balance_wallet, 
                  color: Colors.white, 
                  size: 35.0,
                ),
              ],
            ),
    
            SizedBox(height: 10.0),
    
            Text(subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
    
            const SizedBox(height: 20.0),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
    
                const Text('10/24',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}