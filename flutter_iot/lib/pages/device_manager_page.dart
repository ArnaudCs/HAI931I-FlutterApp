import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/device_card_settings.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';

class DeviceManagerPage extends StatefulWidget {
  const DeviceManagerPage({super.key});

  @override
  State<DeviceManagerPage> createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<DeviceManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingTopCard(
                navBarPrefix: 'My ',
                navBarSuffix: 'Devices',
                title: 'Manage devices',
                subtitle: 'Here you can manage your connected devices, and disconnect them if needed.',
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
              
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Your connected devices',
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.devices_other),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),

                      const Divider(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          children: [
                            DeviceSettingsCard(
                              title: 'ESP 32', 
                              subTitle: 'Added 2 in 2023-01-01', 
                              icon : Icons.delete,
                              iconColor: Colors.red.shade300
                            ),

                            DeviceSettingsCard(
                              title: 'No connected devices', 
                              subTitle: 'Add a new device', 
                              icon : Icons.add,
                              iconColor: Colors.green.shade300
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ),
              )
            ]
          )
        )
      )
    );
  }
}