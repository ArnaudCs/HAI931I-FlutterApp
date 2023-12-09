import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/text_fields.dart';

class TrehsholdSettingsCard extends StatelessWidget {
  final title;
  final input1hint;
  final input2hint;
  final icon;
  final TextEditingController controller1;
  final TextEditingController controller2;
  final Function() onUpdate;

  const TrehsholdSettingsCard({
    super.key,
    required this.title,
    required this.input1hint,
    required this.input2hint,
    required this.icon,
    required this.controller1,
    required this.controller2,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
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
                Icon(
                  icon,
                  color: Colors.grey.shade600,
                )
              ],
            ),
          ),

          const SizedBox(height: 10.0),
          
          CustomTextField(
            hintText: input1hint,
            obscureText: false,
            controller: controller1,
            textFieldIcon: const Icon(Icons.format_indent_decrease),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              onUpdate();
            },
          ),
          const SizedBox(height: 10.0),
          CustomTextField(
            hintText: input2hint,
            obscureText: false,
            controller: controller2,
            textFieldIcon: const Icon(Icons.format_indent_increase),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              onUpdate();
            },
          ),
        ],
      ),
    );
  }
}
