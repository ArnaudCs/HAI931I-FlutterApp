import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/simple_button.dart';

class SimpleNavBar extends StatelessWidget {

  final prefix;
  final suffix;

  const SimpleNavBar({
    super.key,
    required this.prefix,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: SimpleButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icons.arrow_back,
                width: 50,
                height: 50,
              ),
            ),
            Row(
              children: [
                Text(
                  prefix,
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                Text(
                  suffix,
                  style: const TextStyle(
                    fontSize: 32.0,
                    color: Colors.black
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}


