import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DataGauge extends StatelessWidget {

  final brightness;
  final minMarker;
  final maxMarker;
  final minValue;
  final maxValue;

  const DataGauge({
    super.key,
    required this.brightness,
    required this.minMarker,
    required this.maxMarker,
    required this.minValue,
    required this.maxValue
  });

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
      minimum: minValue,
      maximum: maxValue,
      showTicks: true,
      showLabels: true,
      barPointers: [
        LinearBarPointer(
          value: brightness,
          thickness: 20,
          color: Colors.green.shade200,
          edgeStyle: LinearEdgeStyle.bothCurve,
          position: LinearElementPosition.cross,
          animationDuration: 1500,
          animationType: LinearAnimationType.ease,
          shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue.shade100, Colors.blue.shade500])
          .createShader(bounds)
        ),
      ],
      axisTrackStyle: LinearAxisTrackStyle(
        thickness: 20,
        edgeStyle: LinearEdgeStyle.bothCurve,
        color: Colors.grey.shade400,
      ),
      markerPointers: [
        LinearShapePointer(
          value: minMarker,
          offset: 15,
          color: Colors.red.shade300,
          shapeType: LinearShapePointerType.triangle,
          position: LinearElementPosition.inside
        ),
        LinearShapePointer(
          value: maxMarker,
          offset: 15,
          color: Colors.green.shade300,
          shapeType: LinearShapePointerType.triangle,
          position: LinearElementPosition.inside
        ),
      ],
    );   
  }
}