import 'package:flutter/material.dart';

class AlertTile extends StatefulWidget {

  final title;
  final content;
  final sensorId;
  final date;

  const AlertTile({
    super.key,
    required this.title,
    required this.content,
    required this.sensorId,
    required this.date,
  });

  @override
  State<AlertTile> createState() => _AlertTileState();
}

class _AlertTileState extends State<AlertTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Icon(Icons.notification_important_rounded, color: Colors.red.shade300,)
              ],
            ), 

            const SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      widget.content,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        
                const SizedBox(height: 10),
        
                Row(
                  children: [
                    Text(
                      widget.sensorId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.date_range_rounded, size: 15, color: Colors.grey.shade600,),
                const SizedBox(width: 5),
                Text(
                  '${widget.date.day}/${widget.date.month}/${widget.date.year} - ${widget.date.hour}:${widget.date.minute}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    
          ],
        )
      ),
    );
  }
}