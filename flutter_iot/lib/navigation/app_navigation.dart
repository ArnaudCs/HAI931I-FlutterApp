import 'package:flutter/material.dart';
import 'package:flutter_iot/pages/home_page.dart';
import 'package:flutter_iot/pages/setting_page.dart';
import 'package:flutter_iot/pages/weather_page.dart';
import 'package:flutter_iot/pages/wifi-settings.dart';
import 'package:flutter_iot/wrapper/main_wrapper.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {

  AppNavigation._();

  static const String initR = '/home';

  static final _rooterNavigatorKey = GlobalKey<NavigatorState>();
  static final _rooterNavigatorHome = GlobalKey<NavigatorState>();
  static final _rooterNavigatorWeather = GlobalKey<NavigatorState>();
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
                }
              )
            ]
          ),

          //Branch weather
          StatefulShellBranch(
            navigatorKey: _rooterNavigatorWeather,
            routes: [
              GoRoute(
                path: '/weather',
                name: 'Weather',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: const WeatherPage(),
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
                ]
              )
            ]
          ),

        ],
      )
    ]
  );

}