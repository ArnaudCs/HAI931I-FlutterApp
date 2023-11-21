import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/app_bar_home.dart';
import 'package:flutter_iot/utils/simple_button.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:flutter_iot/utils/text_fields.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WifiSettings extends StatelessWidget {

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController securityCodeController = TextEditingController();

  WifiSettings({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SimpleNavBar(
                prefix: 'Wifi ',
                suffix: 'Settings',
              ),

              const SizedBox(height: 20.0),

              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Ajoutez un padding horizontal
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect your LeafLink',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Here you can send WI-FI informations to your ESP for the first connection, or if you need to reconnect it. Make sure to have the security code on your ESP before sending the informations.',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'SSID', 
                      obscureText: false, 
                      controller: ssidController,
                    ),

                    SizedBox(height: 20.0), 

                    CustomTextField(
                      hintText: 'Password', 
                      obscureText: true, 
                      controller: passwordController,
                    ),

                    SizedBox(height: 20.0),

                    SlideAction(
                      text: 'Slide to send',
                      textStyle: TextStyle(
                        color: Colors.green.shade200,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      innerColor: Colors.green.shade200,
                      outerColor: Colors.grey.shade200,
                      onSubmit: () {},
                      elevation: 0,
                      borderRadius: 16,
                      sliderButtonIcon: Icon(Icons.send, color: Colors.white),
                      submittedIcon: Icon(Icons.check, color: Colors.green.shade600),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
