import 'package:flutter/material.dart';

class AlertHeader extends StatelessWidget {

  final title;
  final buttonText;
  final icon;
  final VoidCallback? onPressed;

  const AlertHeader({
    super.key,
    required this.title,
    required this.buttonText,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
    
            GestureDetector(
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            
                    const SizedBox(width: 5),
            
                    Icon(icon, color: Colors.white, size: 20,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}