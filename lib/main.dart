import 'package:flutter/material.dart';
import 'package:task_flow/screens/options_screen.dart';
import 'package:task_flow/screens/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(nextScreen: OptionsScreen()),
    );
  }
}
