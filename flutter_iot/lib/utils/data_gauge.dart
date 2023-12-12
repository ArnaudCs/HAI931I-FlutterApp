import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DataGauge extends StatelessWidget {
  final double humidity;
  final double minTreshold;
  final double maxTreshold;

  const DataGauge({
    super.key,
    required this.humidity,
    required this.minTreshold,
    required this.maxTreshold,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 2000,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          pointers: <GaugePointer>[
            NeedlePointer(value: humidity),
            RangePointer(
              value: humidity,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
              gradient: SweepGradient(
                colors: [Colors.blue.shade200, Colors.blue], // Utilisez la même couleur pour remplir en bleu
                stops: const [0.0, 1.0],
              ),
            ),
            MarkerPointer(
              value: minTreshold, 
              enableDragging: true, 
              markerWidth: 30, 
              markerHeight: 30, 
              markerOffset: -15,
              color: Colors.purple.shade300
            ),

            MarkerPointer(
              value: maxTreshold, 
              enableDragging: true, 
              markerWidth: 30, 
              markerHeight: 30, 
              markerOffset: -15,
              color: Colors.purple.shade200
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: Text(
                  '$humidity%',
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
              colors: [Colors.blue, Colors.green],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}