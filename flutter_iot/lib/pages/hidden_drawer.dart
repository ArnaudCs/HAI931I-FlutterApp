import 'package:flutter/material.dart';
import 'package:flutter_iot/pages/home_page.dart';
import 'package:flutter_iot/pages/setting_page.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {

  List<ScreenHiddenDrawer> _pages = [];

  final navTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 28.0,
    fontWeight: FontWeight.bold
  );

  final selectedNavTextStyle = const TextStyle(
    color: Colors.deepPurple,
    fontSize: 28.0,
    fontWeight: FontWeight.bold
  );

  final selectorColor = Colors.deepPurple;

  @override
  void initState(){
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Home",
          baseStyle: navTextStyle,
          selectedStyle: selectedNavTextStyle,
          colorLineSelected: selectorColor,
        ), 
        const HomePage()
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Settings",
          baseStyle: navTextStyle,
          selectedStyle: selectedNavTextStyle,
          colorLineSelected: selectorColor,
        ), 
        const SettingPage()
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple.shade200,
      backgroundColorAppBar: Colors.blue,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 60.0,
      contentCornerRadius: 40.0,
    );
  }
}