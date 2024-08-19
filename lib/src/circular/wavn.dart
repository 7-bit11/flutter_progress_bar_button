import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('波浪进度按钮')),
        body: Center(
          child: WaveProgressButton(
            width: 200, // 设置按钮宽度
            height: 60, // 设置按钮高度
          ),
        ),
      ),
    );
  }
}

class WaveProgressButton extends StatefulWidget {
  final double width;
  final double height;

  const WaveProgressButton(
      {Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  _WaveProgressButtonState createState() => _WaveProgressButtonState();
}

class _WaveProgressButtonState extends State<WaveProgressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // 动画持续时间
    )..repeat(); // 无限循环播放
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 按钮点击处理
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.width, widget.height), // 使用传入的宽度和高度
            painter: WavePainter(
              animation: _controller,
              progress: 0.6, // 可以动态调整进度
            ),
          ),
          Text(
            "Wave Button",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final double waveHeight = 8.0; // 波浪高度
  final double waveLength = 200.0; // 波浪长度，调整平滑度
  final double waveSpeed = 2.0; // 波浪速度
  final double progress; // 进度

  WavePainter({required this.animation, required this.progress})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()..color = Colors.blueAccent;
    Paint progressPaint = Paint()..color = Colors.red;

    // 绘制进度条背景
    Rect progressRect = Rect.fromLTWH(0, 0, size.width * progress, size.height);
    canvas.drawRect(progressRect, progressPaint);

    // 绘制波浪效果
    Path wavePath = Path();
    double waveOffset = waveSpeed * animation.value * waveLength;

    // 使波浪从画布左侧延伸至右侧，平滑过渡
    wavePath.moveTo(-waveLength + waveOffset, size.height / 2);
    for (double i = -waveLength; i <= size.width + waveLength; i += 1) {
      double y = sin((i / waveLength) * 2 * pi + waveOffset) * waveHeight +
          size.height / 2;
      wavePath.lineTo(i, y);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // 剪切波浪区域
    canvas.clipRect(progressRect);
    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 动画更新时重绘
  }
}
