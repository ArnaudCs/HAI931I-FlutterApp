import 'package:flutter/material.dart';

class ColorPickerTile extends StatefulWidget {

  final String colorName;
  final Color color;
  final size;
  final VoidCallback? onPressed;

  const ColorPickerTile({
    super.key,
    required this.colorName,
    required this.color,
    required this.size,
    this.onPressed,
  });

  @override
  State<ColorPickerTile> createState() => _ColorPickerTileState();
}

class _ColorPickerTileState extends State<ColorPickerTile> {
  bool isSelected = false; // Move the declaration here

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color:Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.colorName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
              const SizedBox(width: 10.0),
      
              Container(
                width: widget.size,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}