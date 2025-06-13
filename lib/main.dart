import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Rick and Morty characters',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(key: Key('splash_screen')),
    );
  }
}
