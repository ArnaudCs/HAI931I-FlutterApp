import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit(){
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult){
    if(connectivityResult == ConnectivityResult.none){
      Get.rawSnackbar(
        messageText: const Text(
          'Please connect to the internet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.red[400]!,
        margin: const EdgeInsets.all(20.0),
        isDismissible: false,
        duration: const Duration(days: 1),
        icon: const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 35,
        ),
        snackStyle: SnackStyle.GROUNDED,
      );
    }
    else {
      if(Get.isSnackbarOpen == true){
        Get.closeCurrentSnackbar();
      }
    }
  }
}
