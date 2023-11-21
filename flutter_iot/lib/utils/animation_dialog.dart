import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final String animPath;
  final colorButton;

  const AnimationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.animPath,
    required this.colorButton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold
        ),
      ),
      shape: RoundedRectangleBorder( // Personnalisez la forme de la boîte de dialogue
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: SingleChildScrollView( // Ajoutez le SingleChildScrollView ici
        child: Column(
          children: [
            Text(
              content,
            ),
            const SizedBox(height: 20),
            Lottie.asset(animPath, width: 150, height: 150),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorButton,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    );
  }
}

