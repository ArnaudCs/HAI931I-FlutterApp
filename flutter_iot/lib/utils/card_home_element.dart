import 'package:flutter/material.dart';

class HomeCardElement extends StatelessWidget {
  final title;
  final subtitle;
  final content;
  final icon;
  final color;
  final imagePath;

  const HomeCardElement({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.icon,
    this.color,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color backgroundColor = color ?? Colors.transparent;
    String cardImagePath = imagePath ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              // Image en arrière-plan depuis une URL
              if (cardImagePath!='')
                Image.network(
                  cardImagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              // Contenu de la carte
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Assurez-vous que la couleur est transparente
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
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
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        const Text(
                          '10/24',
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
            ],
          ),
        ),
      ),
    );
  }
}
