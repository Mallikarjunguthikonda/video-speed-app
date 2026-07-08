import 'package:flutter/material.dart';

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
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.speed, size: 80, color: Colors.blue),
              SizedBox(height: 16),
              Text('Video Speed App', style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text('Minimal test version'),
            ],
          ),
        ),
      ),
    );
  }
}
