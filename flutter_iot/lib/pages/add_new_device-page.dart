import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/settings_top_cards.dart';
import 'package:flutter_iot/utils/text_fields.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {

  TextEditingController deviceNameController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String? scannedData = ''; 
  bool isScanned = false;
  static const String deviceListKey = 'deviceListKey';
  List<Map<String, String>> deviceList = [];
  bool isSliderEnabled = false; 

  void updateSliderState() {
    setState(() {
      isSliderEnabled = deviceNameController.text.isNotEmpty && isScanned;
    });
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
      updateSliderState();
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
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

  void _startScanning() {
    controller?.resumeCamera();
  }

  void _stopScanning() {
    controller?.pauseCamera();
  }

  @override
  void initState() {
    super.initState();
    loadDeviceList(); 
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

  void ShowQRCodeDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text('QR Code'),
          content: Container(
            height: 300,
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.all(10),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
          
                const SizedBox(height: 20.0),
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      _stopScanning(); 
                      deviceNameController.clear();
                      setState(() {
                        scannedData = null;
                        isScanned = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Cancel reading',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                          Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                title: 'Adding devices',
                subtitle: 'Enter a name for the device and scan the QR Code on your device to add it to your account.',
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'Device Name', 
                        obscureText: false, 
                        controller: deviceNameController, 
                        textFieldIcon: const Icon(Icons.label),
                        keyboardType: TextInputType.text, 
                        onChanged: (value) {
                          updateSliderState();
                        }
                      ),

                      const SizedBox(height: 20.0),

                      GestureDetector(
                        onTap: () {
                          ShowQRCodeDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Scan QR Code',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.qr_code_scanner,
                                color: Colors.grey[700],
                                size: 30.0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      isScanned ?
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  extractElementFromScannedData(scannedData!, 3),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    scannedData = null;
                                    isScanned = false;
                                    updateSliderState();
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ) : Container(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SlideAction(
                  text: 'Slide to add',
                  textStyle: TextStyle(
                    color: isSliderEnabled ? Colors.green.shade200 : Colors.grey.shade300,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                  innerColor: isSliderEnabled ? Colors.green.shade200 : Colors.grey.shade300,
                  outerColor: Colors.grey.shade200,
                  onSubmit: () {
                    if (isScanned && deviceNameController.text.isNotEmpty) {
                      DateTime now = DateTime.now();
                      String uniqueId = now.millisecondsSinceEpoch.toString();
                      String deviceAddDate = '${now.year}-${now.month}-${now.day}';
                      String deviceSSID = extractElementFromScannedData(scannedData ?? '', 2);
                      String deviceURL = extractElementFromScannedData(scannedData ?? '', 3);
                      String deviceName = deviceNameController.text;

                      if (RegExp(r'^\d+').hasMatch(deviceURL)) {
                        addDeviceToList(deviceName, deviceAddDate, deviceSSID, uniqueId, deviceURL);
                        deviceNameController.clear();
                        setState(() {
                          scannedData = null;
                          isScanned = false;
                        });
                        Navigator.pop(context);
                      } else {
                        //show error snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('The scanned QR Code is not valid.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  elevation: 0,
                  borderRadius: 16,
                  sliderButtonIcon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  submittedIcon: Icon(Icons.check, color: Colors.green.shade600),
                  animationDuration: const Duration(milliseconds: 400),
                  enabled: isSliderEnabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}