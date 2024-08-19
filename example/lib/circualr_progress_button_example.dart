import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
                    });
                  });
                }),
          ),
          WaveProgressButton(
            width: 200, // 设置按钮宽度
            height: 60, // 设置按钮高度
          )
        ],
      ),
    );
  }
}
