import 'package:flutter/material.dart';
import 'package:flutter_iot/pages/hidden_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: HiddenDrawer(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
