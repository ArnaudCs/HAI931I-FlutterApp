import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DataGauge extends StatelessWidget {
  final double humidity;

  const DataGauge({
    super.key,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 3500,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          pointers: <GaugePointer>[
            NeedlePointer(value: humidity),
            RangePointer(
              value: humidity, // Vous pouvez ajuster la valeur de départ ici
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
              gradient: const SweepGradient(
                colors: [Colors.blue, Colors.blue], // Utilisez la même couleur pour remplir en bleu
                stops: [0.0, 1.0],
              ),
            ),
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