import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/pages/admin_home.dart';
import 'package:skimscope/pages/register.dart';

import 'pages/login.dart';
import 'pages/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skimscope',
      theme: ThemeData(
        primaryColor: Color(0xFF588B8B),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'splash':
            return CupertinoPageRoute(builder: (_) => SplashScreen());
          case 'login':
            return CupertinoPageRoute(builder: (_) => LoginPage());
          case 'register':
            return CupertinoPageRoute(builder: (_) => RegisterPage());
          case 'admin':
            return CupertinoPageRoute(builder: (_) => AdminHomePage());
          default:
            return MaterialPageRoute(
                builder: (_) => Scaffold(
                      body: SafeArea(
                        child: Center(
                          child: Text('No route exists with ${settings.name}.'),
                        ),
                      ),
                    ));
        }
      },
    );
  }
}
