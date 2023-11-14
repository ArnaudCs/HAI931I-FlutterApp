import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/pages/home_page.dart';
import 'package:flutter_iot/pages/setting_page.dart';
import 'package:flutter_iot/pages/weather_page.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  final menus = [
    const Icon(Icons.home, color: Colors.white),
    const Icon(Icons.stacked_bar_chart_sharp, color: Colors.white),
    const Icon(Icons.settings, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        color: Colors.green.shade200,
        items: menus,
        animationCurve: Curves.easeInOutCubic,
        height: 60,
        onTap: (index) {
          setState(() {
            _goToBranch(index);
          });
        },
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: widget.navigationShell,
      ),
    );
  }
}