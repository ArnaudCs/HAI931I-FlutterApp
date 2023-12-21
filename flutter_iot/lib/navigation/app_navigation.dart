import 'package:flutter/material.dart';
import 'package:flutter_iot/pages/addd_new_device-page.dart';
import 'package:flutter_iot/pages/device_manager_page.dart';
import 'package:flutter_iot/pages/factory_reset_page.dart';
import 'package:flutter_iot/pages/home_page.dart';
import 'package:flutter_iot/pages/temperature_page.dart';
import 'package:flutter_iot/pages/brightness_page.dart';
import 'package:flutter_iot/pages/setting_page.dart';
import 'package:flutter_iot/pages/watering_page.dart';
import 'package:flutter_iot/pages/weather_page.dart';
import 'package:flutter_iot/pages/stat_page.dart';
import 'package:flutter_iot/pages/treshold_settings.dart';
import 'package:flutter_iot/pages/wifi_settings.dart';
import 'package:flutter_iot/wrapper/main_wrapper.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {

  AppNavigation._();

  static const String initR = '/home';

  static final _rooterNavigatorKey = GlobalKey<NavigatorState>();
  static final _rooterNavigatorHome = GlobalKey<NavigatorState>();
  static final _rooterNavigatorStats = GlobalKey<NavigatorState>();
  static final _rooterNavigatorSettings = GlobalKey<NavigatorState>();

  static final GoRouter router = 
  GoRouter(
    initialLocation: initR,
    navigatorKey: _rooterNavigatorKey,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[

          //Branch home
          StatefulShellBranch(
            navigatorKey: _rooterNavigatorHome,
            routes: [
              GoRoute(
                path: '/home',
                name: 'Home',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: HomePage(),
                  );
                },

                routes: [

                  GoRoute(
                    path: 'wateringPage',
                    name: 'WateringPage',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const WateringPage(),
                      );
                    }
                  ),

                  //Page
                  GoRoute(
                    path: 'brightnessPage',
                    name: 'BrightnessPage',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const BrightnessPage(),
                      );
                    }
                  ),

                  GoRoute(
                    path: 'temperaturePage',
                    name: 'TemperaturePage',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const TemperaturePage(),
                      );
                    }
                  ),

                  GoRoute(
                    path: 'weatherPage',
                    name: 'WeatherPage',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const WeatherPage(),
                      );
                    }
                  ),
                ]
              )
            ]
          ),

          //Branch weather
          StatefulShellBranch(
            navigatorKey: _rooterNavigatorStats,
            routes: [
              GoRoute(
                path: '/stats',
                name: 'Statistics',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: const StatPage(),
                  );
                }
              )
            ]
          ),

          //Branch settings
          StatefulShellBranch(
            navigatorKey: _rooterNavigatorSettings,
            routes: [
              GoRoute(
                path: '/settings',
                name: 'Settings',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: const SettingPage(),
                  );
                },

                routes: [
                  //SubSetting Page
                  GoRoute(
                    path: 'wifiSettings',
                    name: 'WifiSettings',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const WifiSettings(),
                      );
                    }
                  ),

                  GoRoute(
                    path: 'tresholdSettings',
                    name: 'TresholdSettings',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const TresholdSettings(),
                      );
                    }
                  ),

                  GoRoute(
                    path: 'deviceManagerSettings',
                    name: 'DeviceManagerSettings',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const DeviceManagerPage(),
                      );
                    },

                    routes: [
                      GoRoute(
                        path: 'addDevicePage',
                        name: 'AddDevicePage',
                        pageBuilder: (context, state) {
                          return MaterialPage(
                            key: state.pageKey,
                            child: const AddDevicePage(),
                          );
                        }
                      ),
                    ]
                  ),

                  GoRoute(
                    path: 'factoryResetSettings',
                    name: 'FactoryResetSettings',
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const FactoryResetPage(),
                      );
                    }
                  ),
                ]
              )
            ]
          ),

        ],
      )
    ]
  );

}