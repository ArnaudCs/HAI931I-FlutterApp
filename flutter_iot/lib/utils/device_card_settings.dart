import 'package:flutter/material.dart ';

class DeviceSettingsCard extends StatefulWidget {

  final String title;
  final String subTitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  const DeviceSettingsCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconColor,
    this.onPressed,
  });

  @override
  State<DeviceSettingsCard> createState() => _DeviceSettingsCardState();
}

class _DeviceSettingsCardState extends State<DeviceSettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
    
                const SizedBox(height: 5.0),
    
                Text(
                  widget.subTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            )
          ),
          GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              decoration: BoxDecoration(
                color: widget.iconColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: IconButton(
                icon: Icon(
                  widget.icon,
                  color: Colors.white,
                ),
                onPressed: widget.onPressed, 
              ),
            ),
          )
        ]),
      ),
    );
  }
}