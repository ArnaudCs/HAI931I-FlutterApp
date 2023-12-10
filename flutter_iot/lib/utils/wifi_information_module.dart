import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WifiInformationModule extends StatefulWidget {
  WifiInformationModule({Key? key}) : super(key: key);

  @override
  _WifiInformationModuleState createState() => _WifiInformationModuleState();
}

class _WifiInformationModuleState extends State<WifiInformationModule> {
  final NetworkInfo info = NetworkInfo();
  late final wifiName;
  late final wifiBSSID;
  late final wifiIP;
  late final wifiIPv6;
  late final wifiSubmask;
  late final wifiBroadcast;
  late final wifiGateway;

  @override
  void initState() {
    super.initState();
    getWifiInfo();
  }

  Future<void> getWifiInfo() async {
    wifiName = await info.getWifiName(); // "FooNetwork"
    wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
    wifiIP = await info.getWifiIP(); // 192.168.1.43
    wifiIPv6 = await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
    wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
    wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
    wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1
    setState(() {}); // Refresh the widget with the new data
    print('Wifi Name: $wifiName');
    /* print('Wifi BSSID: $wifiBSSID');
    print('Wifi IP: $wifiIP');
    print('Wifi IPv6: $wifiIPv6');
    print('Wifi Submask: $wifiSubmask');
    print('Wifi Broadcast: $wifiBroadcast');
    print('Wifi Gateway: $wifiGateway'); */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        wifiName,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
