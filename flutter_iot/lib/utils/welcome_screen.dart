import 'package:flutter/material.dart';
import 'package:flutter_iot/main.dart';
import 'package:flutter_iot/utils/intro_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeSlides extends StatefulWidget {
  const WelcomeSlides({super.key});

  @override
  State<WelcomeSlides> createState() => _WelcomeSlidesState();
}

class _WelcomeSlidesState extends State<WelcomeSlides> {

  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: [
                IntroPages(
                  animationPath: 'assets/anim_connect_plant.json',
                  introText: 'Connect your plant to the app',
                  slideColor: Colors.green.shade100,
                ),
                IntroPages(
                  animationPath: 'assets/anim_track_data.json',
                  introText: 'Track your plant\'s health',
                  slideColor: Colors.blue.shade100,
                ),
                IntroPages(
                  animationPath: 'assets/anim_change_settings.json',
                  introText: 'Manage settings and tresholds',
                  slideColor: Colors.orange.shade100,
                ),
              ],
            ),

            Container(
              alignment: Alignment(0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  onLastPage ?  
                    const Text(
                      '',
                    ) : 
                    GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(2);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),

                  SmoothPageIndicator(
                    controller: _controller, 
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                      spacing: 5
                    ),
                  ),

                  onLastPage ? 
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                        );
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ) : 
                    GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400), 
                          curve: Curves.easeInOut
                        );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}