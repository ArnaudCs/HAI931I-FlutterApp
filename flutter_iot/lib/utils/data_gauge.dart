import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/date_display.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DataGauge extends StatelessWidget {
  final temperature;
  final minThreshold;
  final maxThreshold;

  const DataGauge({
    super.key,
    required this.temperature,
    required this.minThreshold,
    required this.maxThreshold,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),

        const Text(
          'Temperature',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: -10,
              maximum: 100,
              pointers: <GaugePointer>[
                NeedlePointer(value: temperature),
                RangePointer(
                  value: temperature,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                  cornerStyle: CornerStyle.bothCurve,
                  gradient: SweepGradient(
                    colors: [Colors.blue.shade200, Colors.orange.shade200], // Utilisez la même couleur pour remplir en bleu
                    stops: const [0.0, 1.0],
                  ),
                ),
                MarkerPointer(
                  value: minThreshold, 
                  enableDragging: true, 
                  markerWidth: 30, 
                  markerHeight: 30, 
                  markerOffset: -15,
                  color: Colors.blue
                ),
  
                MarkerPointer(
                  value: maxThreshold, 
                  enableDragging: true, 
                  markerWidth: 30, 
                  markerHeight: 30, 
                  markerOffset: -15,
                  color: Colors.orange.shade300
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Container(
                    child: Text(
                      '$temperature °C',
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.5,
                ),
              ],
              showTicks: false,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                thicknessUnit: GaugeSizeUnit.factor,
                gradient: SweepGradient(
                  colors: [Colors.blue, Colors.orange],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ],
        ),
        DateDisplay(),
        
        const SizedBox(height: 5),
      ],
    );
  }
}