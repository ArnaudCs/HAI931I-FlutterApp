import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LongButton extends StatelessWidget {

  final title;
  final description;
  final imagePath;
  final VoidCallback? onPressed;

  const LongButton({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: onPressed, // Utilisez le callback onPressed pour la redirection
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                offset: const Offset(5, 5),
                blurRadius: 15,
                spreadRadius: 1.0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-5, -5),
                blurRadius: 15,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(children: [
                      Container(
                        height: 80,
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(imagePath),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(description),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: const Icon(Icons.arrow_forward_ios_rounded)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}