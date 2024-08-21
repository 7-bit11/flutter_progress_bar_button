import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_button/flutter_progress_bar_button.dart';

class CircualrProgressButtonExample extends StatefulWidget {
  const CircualrProgressButtonExample({super.key});

  @override
  State<CircualrProgressButtonExample> createState() =>
      _WaterWaveProgressPageState();
}

class _WaterWaveProgressPageState extends State<CircualrProgressButtonExample> {
  int progress = 6;
  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("水波球形进度条")),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          progress = 0;
        });
      }),
      body: Column(
        children: [
          Center(
            child: CircularAnimatedProgressBar(
                size: 150,
                progress: (progress.clamp(0, 10) / 10),
                onPressed: () {
                  setState(() {
                    progress += 2;
                  });
                }),
          ),
          const SizedBox(height: 20),
          RectangleAnimatedProgressBar(
            progress: (progress.clamp(0, 10) / 10),
            enumPosition: PositionEnum.right,
            colorsWave: const [
              Color(0x4D2196f3),
              Color(0x662196f3),
              Color(0xCC2196f3),
            ],
            backgroundColor: const Color(0x262192F3),
          ),
          const SizedBox(height: 20),
          RectangleAnimatedProgressBar(
            progress: (progress.clamp(0, 10) / 10),
            enumPosition: PositionEnum.left,
          ),
          const SizedBox(height: 20),
          RectangleAnimatedProgressBar(
            progress: (progress.clamp(0, 10) / 10),
            enumPosition: PositionEnum.bottom,
          )
        ],
      ),
    );
  }
}
