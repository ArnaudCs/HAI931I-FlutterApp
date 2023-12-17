import 'package:flutter/material.dart';
import 'package:flutter_iot/services/weather_service.dart';
import 'package:flutter_iot/models/weather_model.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('9ac3a60a3ff2ad0c3ef4781a6514c4a0'); 
  Weather? _weather;
  
  // avoiding constant reloading of data
  bool _dataFetched = false;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _dataFetched = true; // Marquez les données comme récupérées
      });
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_dataFetched) {
      _fetchWeather();
    }
  }

  String getWeatherAnim(String? weatherCondition){
    if(weatherCondition == 'Clear'){
      return 'assets/anim_sunny.json';
    }else if(weatherCondition == 'Clouds'){
      return 'assets/anim_cloudy.json';
    }else if(weatherCondition == 'Rain'){
      return 'assets/anim_thunder.json';
    }else if(weatherCondition == 'Snow'){
      return 'assets/anim_snowy.json';
    }else{
      return 'assets/anim_sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const AppBarHome(
          prefix: "Weather",
          suffix: "Link",
          icon: Icons.qr_code,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100, bottom: 10), // Ajoutez des marges en haut et en bas
                  child: Text(
                    _weather?.cityName ?? 'Weather ...',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),

                Lottie.asset(
                  getWeatherAnim(_weather?.condition),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10), // Ajoutez des marges en haut et en bas
                  child: Text(
                    '${_weather?.temperature.round()}°C',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  _weather?.condition ?? 'Fetching temperature ...',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}