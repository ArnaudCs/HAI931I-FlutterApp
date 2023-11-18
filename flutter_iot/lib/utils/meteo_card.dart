import 'package:flutter/material.dart';
import 'package:flutter_iot/services/weather_service.dart';
import 'package:flutter_iot/models/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {

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

  String getWeatherBackground(String? weatherCondition){
    if(weatherCondition == 'Clear'){
      return 'assets/WeatherCardBackground/clear.jpg';
    }else if(weatherCondition == 'Clouds'){
      return 'assets/WeatherCardBackground/cloudy.jpg';
    }else if(weatherCondition == 'Rain'){
      return 'assets/WeatherCardBackground/thunder.jpg';
    }else if(weatherCondition == 'Snow'){
      return 'assets/WeatherCardBackground/snow.jpg';
    }else{
      return 'assets/WeatherCardBackground/sunny.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                // Image en arrière-plan depuis une URL
                Image.asset(
                  getWeatherBackground(_weather?.condition), // Assure-toi que le chemin vers l'image est correct
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Contenu de la carte
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 99, 48, 48), // Assurez-vous que la couleur est transparente
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _weather?.cityName ?? 'Weather ...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0,
                              ),
                            ),
                          ),
                          Lottie.asset(
                            getWeatherAnim(_weather?.condition),
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${_weather?.temperature.round()}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _weather?.condition ?? 'Fetching temperature ...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}