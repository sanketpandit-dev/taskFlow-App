import 'package:TaskFlow/screens/LoginScreen.dart';
import 'package:TaskFlow/screens/options_screen.dart';
import 'package:TaskFlow/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Future.wait([
          _storage.read(key: "auth_token"),
          _storage.read(key: "userId"),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final token = snapshot.data?[0];
            final userId = snapshot.data?[1];

            return SplashScreen(
              nextScreen: (token != null && userId != null)
                  ? OptionsScreen()
                  : LoginScreen(),
            );
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}