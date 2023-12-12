import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatefulWidget {
  final city;
  final condition;
  final temperature;

  const WeatherCard({
    super.key,
    required this.city,
    required this.condition,
    required this.temperature,
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {

  String getWeatherAnim(String? weatherCondition){
    if(weatherCondition == 'Clear'){
      return 'assets/anim_sunny.json';
    }else if(weatherCondition == 'Clouds'){
      return 'assets/anim_cloudy.json';
    }else if(weatherCondition == 'Rain' || weatherCondition == 'Thunderstorm'){
      return 'assets/anim_thunder.json';
    }else if(weatherCondition == 'Snow'){
      return 'assets/anim_snowy.json';
    }else if(weatherCondition == 'Mist' || weatherCondition == 'Drizzle'){
      return 'assets/anim_mist.json';
    }else{
      return 'assets/anim_sunny.json';
    }
  }

  String getWeatherBackground(String? weatherCondition){
    if(weatherCondition == 'Clear'){
      return 'assets/WeatherCardBackground/clear.jpg';
    }else if(weatherCondition == 'Clouds'){
      return 'assets/WeatherCardBackground/cloudy.jpg';
    }else if(weatherCondition == 'Rain' || weatherCondition == 'Thunderstorm'){
      return 'assets/WeatherCardBackground/thunder.jpg';
    }else if(weatherCondition == 'Snow'){
      return 'assets/WeatherCardBackground/snow.jpg';
    }else if(weatherCondition == 'Mist'){
      return 'assets/WeatherCardBackground/mist.jpg';
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
                  getWeatherBackground(widget.condition), // Assure-toi que le chemin vers l'image est correct
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
                              widget.city,
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
                            getWeatherAnim(widget.condition),
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${widget.temperature}°C',
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
                            widget.condition ?? 'Fetching temperature ...',
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