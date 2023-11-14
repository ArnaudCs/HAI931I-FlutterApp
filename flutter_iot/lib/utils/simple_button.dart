import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double width;
  final double height;

  const SimpleButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
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
          child: SizedBox(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
