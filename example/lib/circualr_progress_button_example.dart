import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_button/flutter_progress_bar_button.dart';

class CircualrProgressButtonExample extends StatefulWidget {
  const CircualrProgressButtonExample({super.key});

  @override
  State<CircualrProgressButtonExample> createState() =>
      _WaterWaveProgressPageState();
}

class _WaterWaveProgressPageState extends State<CircualrProgressButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("水波球形进度条")),
      body: CircularAnimatedProgressBar(),
    );
  }
}
