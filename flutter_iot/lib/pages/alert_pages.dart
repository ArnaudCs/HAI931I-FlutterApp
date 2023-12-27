import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot/models/alerts_model.dart';
import 'package:flutter_iot/utils/alert_header.dart';
import 'package:flutter_iot/utils/alert_tile.dart';
import 'package:flutter_iot/utils/simple_nav_top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  List<String> actualUsedDevice = [];
  bool _dataFetched = true;
  String deviceName = '';
  List<Alerts> alerts = [];

  Future<void> loadUsedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    actualUsedDevice = prefs.getStringList('actualUsedDevice') ?? [];
    deviceName = '${actualUsedDevice[0]} - ${actualUsedDevice[1]}';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUsedDevice();
    fetchAlertsData(deviceName);
  }

  Future<List<Alerts>> fetchAlertsData(String deviceName) async {
    List<Alerts> alertsList = [];
    try {
      String collectionPath = '$deviceName - Alerts';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionPath).get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('content') &&
            data.containsKey('title') &&
            data.containsKey('date') &&
            data.containsKey('sensorId')) {
          Alerts alert = Alerts(
            content: data['content'],
            title: data['title'],
            date: data['date'].toDate(),
            sensorId: data['sensorId'],
          );
          alertsList.add(alert);
        }
        if(alertsList.isEmpty) {
          _dataFetched = false;
        }
      }
    } catch (error) {
      print('Error fetching alerts data: $error');
    }
    return alertsList;
  }

  Future<void> deleteAllAlerts(String deviceName) async {
    try {
      String collectionPath = '$deviceName - Alerts';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionPath).get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
      print('All alerts deleted successfully.');
      setState(() {});
      fetchAlertsData(deviceName);
    } catch (error) {
      print('Error deleting alerts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SimpleNavBar(
              prefix: 'My ',
              suffix: 'Alerts',
            ),

            _dataFetched ? 
              AlertHeader (
                title: 'Alerts',
                buttonText: 'Clear all',
                icon: Icons.delete_forever_rounded,
                onPressed: () async {
                  await deleteAllAlerts(deviceName);
                },
              ) : Container(),

            FutureBuilder<List<Alerts>>(
              future: fetchAlertsData(deviceName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No alerts available.');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Alerts alert = snapshot.data![index];
                        return AlertTile(title: alert.title, content: alert.content, sensorId: alert.sensorId, date: alert.date);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}