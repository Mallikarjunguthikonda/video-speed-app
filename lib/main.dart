import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VideoSpeedApp());
}

class VideoSpeedApp extends StatelessWidget {
  const VideoSpeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Speed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
