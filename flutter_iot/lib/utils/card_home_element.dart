import 'package:flutter/material.dart';

class HomeCardElement extends StatelessWidget {
  final title;
  final subtitle;
  final content;
  final icon;
  final date;
  final color;
  final imagePath;
  final titleSize;
  final contentSize;
  final contentFontWeight;
  final titleFontWeight;

  const HomeCardElement({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.icon,
    required this.date,
    this.color,
    this.imagePath,
    required this.titleSize,
    required this.contentSize,
    required this.contentFontWeight,
    required this.titleFontWeight,
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
                Image.asset(
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: titleFontWeight,
                              fontSize: titleSize,
                            ),
                          ),
                        ),
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 35.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentSize,
                          fontWeight: contentFontWeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${date.hour}:${date.minute}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          '${date.month}/${date.year}',
                          style: const TextStyle(
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
