import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const AppBarHome(prefix: "My", suffix: "Stats", icon: Icons.pie_chart_sharp),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                
              ],
            )
          )
        )
      )
    );
  }
}