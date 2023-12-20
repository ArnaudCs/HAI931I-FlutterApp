import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/device_card_settings.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:flutter_iot/utils/text_fields.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceManagerPage extends StatefulWidget {
  const DeviceManagerPage({super.key});

  @override
  State<DeviceManagerPage> createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<DeviceManagerPage> {
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];
  TextEditingController deviceNameController = TextEditingController();
  bool validDeviceName = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String? scannedData; 
  bool isScanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((Barcode scanData) {
      setState(() {
        scannedData = scanData.code;
        isScanned = true;
      });
      _stopScanning();
    });
  }

  void _startScanning() {
    controller?.resumeCamera();
  }

  void _stopScanning() {
    controller?.pauseCamera();
  }

  Future<void> loadDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(deviceListKey);
    if (savedList != null) {
      deviceList = savedList.map<Map<String, String>>((jsonString) {
        final dynamicMap = jsonDecode(jsonString);
        return Map<String, String>.from(dynamicMap); // Convert dynamic to String
      }).toList();
    }
    setState(() {});
  }

  Future<void> saveDeviceList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = deviceList.map((device) => jsonEncode(device)).toList();
    prefs.setStringList(deviceListKey, jsonStringList);
  }

  Future<void> addDeviceToList(String deviceName, String deviceAddDate, String deviceSSID, String deviceId, String deviceURL) async {
    final newDevice = {'deviceId': deviceId, 'deviceName': deviceName, 'deviceAddDate': deviceAddDate, 'deviceSSID': deviceSSID, 'deviceURL': deviceURL};
    deviceList.add(newDevice);
    await saveDeviceList();
    await setUsedDevice(newDevice);
    setState(() {});
  }

  Future<void> setUsedDevice(Map<String, String> deviceDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = deviceDetails['deviceId'] ?? '';
    prefs.setStringList(
      'actualUsedDevice',
      [deviceId, deviceDetails['deviceName'] ?? '', deviceDetails['deviceSSID'] ?? '', deviceDetails['deviceURL'] ?? ''],
    );
    print(prefs.getStringList('actualUsedDevice'));
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList(); 
  }

  Future<void> removeDeviceById(String deviceId) async {
    deviceList.removeWhere((device) => device['deviceId'] == deviceId);
    await saveDeviceList();
    await loadDeviceList();
    if (deviceList.isNotEmpty) {
      await setUsedDevice(deviceList[0]);
    } else {
      await setUsedDevice({});
    }
    setState(() {});
  }

  void validateName() {
    if(deviceNameController.text.isNotEmpty && deviceNameController.text != ''){
      setState(() {
        validDeviceName = true;
      });
    }
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add new device',
            style: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.bold
            )
          ),
          shape: RoundedRectangleBorder( // Personnalisez la forme de la boîte de dialogue
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                hintText: 'Device Name', 
                obscureText: false, 
                controller: deviceNameController, 
                textFieldIcon: const Icon(Icons.label),
                keyboardType: TextInputType.text, 
                onChanged: (value) {
                  deviceNameController.text = value;
                  validateName();
                }
              ),

              const SizedBox(height: 20.0),

              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(10),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _stopScanning(); 
                deviceNameController.clear();
                setState(() {
                  scannedData = null;
                  isScanned = false;
                  validDeviceName = false;
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _stopScanning(); 
                Navigator.pop(context);
              },
              child: GestureDetector(
                onTap: () {
                  if(isScanned && validDeviceName){
                    DateTime now = DateTime.now();
                    String uniqueId = now.millisecondsSinceEpoch.toString();
                    String deviceAddDate = '${now.year}-${now.month}-${now.day}';
                    String deviceSSID = extractElementFromScannedData(scannedData ?? '', 2);
                    String deviceURL = extractElementFromScannedData(scannedData ?? '', 3);
                    String deviceName = deviceNameController.text;
                    addDeviceToList(deviceName, deviceAddDate, deviceSSID, uniqueId, deviceURL);
                    deviceNameController.clear();
                    setState(() {
                      scannedData = null;
                      isScanned = false;
                      validDeviceName = false;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Text(
                    'Add device',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  String extractElementFromScannedData(String scannedData, int elementNumber) {
    List<String> parts = scannedData.split('||');
    if (elementNumber >= 1 && elementNumber <= parts.length) {
      String element = parts[elementNumber - 1].trim();
      return element;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                                onPressed: () {
                                  DateTime now = DateTime.now();
                                  String uniqueId = now.millisecondsSinceEpoch.toString();
                                  showAddDialog();
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      const Divider(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: deviceList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final device = deviceList[index];
                            return DeviceSettingsCard(
                              title: device['deviceName'] ?? '',
                              subTitle: 'Added on ${device['deviceAddDate']}' ?? '',
                              icon: Icons.delete,
                              iconColor: Colors.red.shade300,
                              onPressed: () {
                                final deviceId = device['deviceId'];
                                if (deviceId != null) {
                                  removeDeviceById(deviceId);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ),
              ),

              const SizedBox(height: 100.0),
            ]
          )
        )
      )
    );
  }
}