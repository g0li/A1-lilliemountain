import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/pages/admin_home.dart';
import 'package:skimscope/pages/create_service.dart';
import 'package:skimscope/pages/employee_home.dart';
import 'package:skimscope/pages/equipment_detail.dart';
import 'package:skimscope/pages/equipment_page.dart';
import 'package:skimscope/pages/history.dart';
import 'package:skimscope/pages/register.dart';

import 'pages/employee.dart';
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
          case 'equipment':
            return CupertinoPageRoute(builder: (_) => EquipmentPage());
          case 'edetails':
            return CupertinoPageRoute(
                builder: (_) => EquipmentDetailPage(
                      equipment: settings.arguments,
                    ));
          case 'ceservice':
            return CupertinoPageRoute(builder: (_) => CreateEditServicePage());
          case 'employee':
            return CupertinoPageRoute(builder: (_) => EmployeePage());
          case 'employeeH':
            return CupertinoPageRoute(builder: (_) => EmployeeHomePage());
          case 'history':
            return CupertinoPageRoute(builder: (_) => HistoryPage());
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
