import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iot/utils/cubic_card_element.dart';
import 'package:flutter_iot/utils/card_home_element.dart';
import 'package:flutter_iot/utils/long_button.dart';
import 'package:flutter_iot/utils/meteo_card.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  void handleRouting(BuildContext context, String name) {
    context.goNamed(name);
  }

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom],
    );
    
    // Bloc used to animate the cards
    /* Future.delayed(Duration.zero, () {
      Timer.periodic(const Duration(seconds: 15), (Timer timer) {
        if (_currentPage < 3) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeIn,
        );
      });
    }); */

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom]
    );
    return Scaffold(
      extendBody: true, // required
      backgroundColor: Colors.grey[300],
      
      appBar: AppBar(
        title: const AppBarHome(prefix: "Leaf", suffix: "Link", icon: Icons.qr_code),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),

              //Liste de boutons
              SizedBox(
                height: 170,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  children: [
                    const WeatherCard(),
                    const HomeCardElement(
                      title: 'Title',
                      subtitle: 'Subtitle',
                      content: 'Content',
                      icon: Icons.account_balance_wallet,  
                      color: null,
                      imagePath: 'assets/Images/forest.jpg',
                    ),
                    HomeCardElement(
                      title: 'Title',
                      subtitle: 'Subtitle',
                      content: 'Content',
                      icon: Icons.account_balance_wallet,
                      color: Colors.deepPurple.shade300,
                      imagePath: '',
                    ),
                    HomeCardElement(
                      title: 'Title',
                      subtitle: 'Subtitle',
                      content: 'Content',
                      icon: Icons.account_balance_wallet,
                      color: Colors.green[200],
                      imagePath: '',
                    ),
                ],),
              ),
        
              const SizedBox(height: 10.0),
        
              SmoothPageIndicator(
                controller: _controller, 
                count: 4,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.grey,
                  dotColor: Colors.grey,
                  dotHeight: 12.0,
                  dotWidth: 12.0,
                  expansionFactor: 3,
                ),
              ),
        
              const SizedBox(height: 25.0),
        
              //Cubic Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CubicCardElement(
                      iconImagePath: 'lib/icons/plante.png',
                      descriptionText: 'Tracking',
                      onPressed: () {
                        handleRouting(context, 'HumidityPage');
                      },
                    ),
              
                    CubicCardElement(
                      iconImagePath: 'lib/icons/eau.png',
                      descriptionText: 'Humidity',
                      onPressed: () {
                        handleRouting(context, 'HumidityPage');
                      },
                    ),
              
                    CubicCardElement(
                      iconImagePath: 'lib/icons/luminosité.png',
                      descriptionText: 'Brightness',
                      onPressed: () {
                        handleRouting(context, 'BrightnessPage');
                      },
                    ),
                  ]),
              ),
        
              //Long Buttons
              const Padding(
                padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
                child: Column(
                  children: [
                    LongButton(
                      title: 'Weather',
                      description: 'Check the weather',
                      imagePath: 'lib/icons/météo.png',
                      
                    ),
        
                    LongButton(
                      title: 'Alerts',
                      description: 'Check the alerts',
                      imagePath: 'lib/icons/alarme.png',
                    ),

                  ],
                ), 
              ),

              const SizedBox(height: 100.0),

            ]),
        ),
      ),
    );
  }
}