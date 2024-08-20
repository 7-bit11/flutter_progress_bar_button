import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_button/flutter_progress_bar_button.dart';

class CircualrProgressButtonExample extends StatefulWidget {
  const CircualrProgressButtonExample({super.key});

  @override
  State<CircualrProgressButtonExample> createState() =>
      _WaterWaveProgressPageState();
}

class _WaterWaveProgressPageState extends State<CircualrProgressButtonExample> {
  double progress = 0.0;
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
                size: 100,
                progress: progress.clamp(0, 1),
                onPressed: () {
                  Timer.periodic(const Duration(milliseconds: 1000), (t) {
                    setState(() {
                      progress += .1;
                      if (progress >= .5) {
                        t.cancel();
                      }
                    });
                  });
                }),
          ),
          const SizedBox(height: 20),
          RectangleAnimatedProgressBar(
              progress: progress.clamp(0, 1),
              enumPosition: PositionEnum.right,
              colorsWave: const [
                Color(0x4D2196f3),
                Color(0x662196f3),
                Color(0xCC2196f3),
              ],
              backgroundColor: const Color.fromARGB(204, 243, 33, 33)),
          const SizedBox(height: 20),
          RectangleAnimatedProgressBar(
              progress: progress.clamp(0, 1),
              enumPosition: PositionEnum.left,
              colorsWave: const [
                Color(0x4D2196f3),
                Color(0x662196f3),
                Color(0xCC2196f3),
              ],
              backgroundColor: const Color.fromARGB(204, 243, 33, 33)),
          const SizedBox(height: 20),
          RectangleAnimatedProgressBar(
              progress: progress.clamp(0, 1),
              enumPosition: PositionEnum.bottom,
              colorsWave: const [
                Color(0x4D2196f3),
                Color(0x662196f3),
                Color(0xCC2196f3),
              ],
              backgroundColor: const Color.fromARGB(204, 243, 33, 33))
        ],
      ),
    );
  }
}
