import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkController {
  final Connectivity _connectivity = Connectivity();
  late BuildContext _context; // Ajout de la référence au contexte

  // Méthode pour initialiser le contrôleur avec le contexte
  void initialize(BuildContext context) {
    _context = context;
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Utilisation de ScaffoldMessenger pour afficher la snackbar
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please connect to the internet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red[400],
          duration: Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(_context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } else {
      // Fermer la snackbar si elle est ouverte
      ScaffoldMessenger.of(_context).hideCurrentSnackBar();
    }
  }
}