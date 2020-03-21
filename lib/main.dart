import 'package:flutter/material.dart';

import 'pages/add_channel/add_channel_page.dart';
import 'pages/add_channel/add_users_page.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'services/navigation_service.dart';
import 'services/service_locator.dart';
import 'styles/theme.dart';

void main() async {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AuthPage.route,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      navigatorKey: locator<NavigationService>().navigatorKey,
      routes: {
        AuthPage.route: (context) => AuthPage(),
        HomePage.route: (context) => HomePage(),
        AddUsersPage.route: (context) => AddUsersPage(),
        AddChannelPage.route: (context) => AddChannelPage(),
      },
    );
  }
}
