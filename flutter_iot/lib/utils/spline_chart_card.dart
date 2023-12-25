import 'package:flutter/material.dart';
import 'package:flutter_iot/models/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChartCard extends StatelessWidget {

  final chartTitle;
  final absLabel;
  final ordLabel;
  final icon;
  final List<ChartData> chartData;

  const SplineChartCard({
    super.key,
    required this.chartTitle,
    required this.absLabel,
    required this.ordLabel,
    required this.icon,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: EdgeInsets.all(15),
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
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chartTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            
                  Icon(
                    icon,
                    color: Colors.grey[700],
                    size: 30,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                name: absLabel,
                labelStyle: TextStyle(color: Colors.black), // Style des étiquettes
              ),

              primaryYAxis: NumericAxis(
                name: ordLabel,
                anchorRangeToVisiblePoints: true,
                labelStyle: TextStyle(color: Colors.black), // Style des étiquettes
              ),

              series: <CartesianSeries>[
                SplineAreaSeries<ChartData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.date,
                  yValueMapper: (ChartData data, _) => data.value,
                  animationDuration: 5000, // Durée de l'animation en millisecondes
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}