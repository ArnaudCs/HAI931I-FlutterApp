import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WifiInformationModule extends StatefulWidget {
  const WifiInformationModule({Key? key}) : super(key: key);

  @override
  _WifiInformationModuleState createState() => _WifiInformationModuleState();
}

class _WifiInformationModuleState extends State<WifiInformationModule> {
  final NetworkInfo info = NetworkInfo();
  String? wifiName;  
  String? wifiBSSID; 
  String? wifiIP;    
  String? wifiIPv6;  
  String? wifiSubmask;
  String? wifiBroadcast;
  String? wifiGateway;

  @override
  void initState() {
    super.initState();
    getWifiInfo();
  }

  Future<void> getWifiInfo() async {
    wifiName = await info.getWifiName();
    wifiBSSID = await info.getWifiBSSID();
    wifiIP = await info.getWifiIP();
    wifiIPv6 = await info.getWifiIPv6();
    wifiSubmask = await info.getWifiSubmask();
    wifiBroadcast = await info.getWifiBroadcast();
    wifiGateway = await info.getWifiGatewayIP();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your actual Wi-Fi', // Use a default value if wifiName is null
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Icon(
                  Icons.wifi,
                  color: Colors.black,
                )
              ],
            ),

            const SizedBox(height: 10.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    wifiName ?? 'No Wi-Fi detected',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10.0),

            const Text(
              "If you don't see your Wi-Fi, please check your ESP, and make sure it's connected to your Wi-Fi.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
      ),
    );
  }
}
