import 'package:flutter/material.dart';
import 'package:flutter_iot/dependency_injection.dart';
import 'package:flutter_iot/navigation/app_navigation.dart';
import 'package:flutter_iot/pages/app_intro_slides.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  await initSharedPreferences(); // Ajout de cette ligne pour initialiser SharedPreferences
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;

  LocationPermission permission = await Geolocator.requestPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
  }

  if (isFirstRun) {
    runApp(const IntroSlides());
    await prefs.setBool('isFirstRun', false);
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}