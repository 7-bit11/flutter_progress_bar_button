// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';

/// 进度条
class CircularAnimatedProgressBar extends StatefulWidget {
  /// 进度
  late double progress;

  /// 大小
  late double size;

  /// 构造方法
  CircularAnimatedProgressBar(
      {super.key, this.progress = 0.0, double size = 150})
      : assert(size > 0, "The size must be greater than 0"),
        assert(progress < 0 || progress > 1,
            "Progress must be less than 1 and greater than 0");
  @override
  _CircularAnimatedProgressBarState createState() =>
      _CircularAnimatedProgressBarState();
}

class _CircularAnimatedProgressBarState
    extends State<CircularAnimatedProgressBar> {
  @override
  Widget build(BuildContext context) {
    return WaterWaveProgressBar(size: widget.size, progress: widget.progress);
  }
}

class WaterWaveProgressBar extends StatefulWidget {
  final double size;
  final double progress;

  const WaterWaveProgressBar(
      {super.key, required this.size, required this.progress});

  @override
  _WaterWaveProgressBarState createState() => _WaterWaveProgressBarState();
}

class _WaterWaveProgressBarState extends State<WaterWaveProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _waveController;
  late Animation<double> _progressAnimation;
  late double _oldProgress;

  @override
  void initState() {
    super.initState();
    _oldProgress = widget.progress;

    // 进度动画控制器
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _progressAnimation =
        Tween<double>(begin: _oldProgress, end: widget.progress).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // 水波纹动画控制器，保持循环
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // 循环执行水波纹动画
  }

  @override
  void didUpdateWidget(WaterWaveProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _oldProgress = oldWidget.progress;
      _progressAnimation =
          Tween<double>(begin: _oldProgress, end: widget.progress).animate(
        CurvedAnimation(
            parent: _progressController, curve: Curves.easeInOutCirc),
      );

      // 开始执行进度动画
      _progressController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressController, _waveController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: MultiLayerWaterWavePainter(
                      _waveController.value, _progressAnimation.value),
                )),
            Text(
              '${(_progressAnimation.value * 100).toInt()}%',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}

class MultiLayerWaterWavePainter extends CustomPainter {
  final double waveAnimationValue;
  final double progress;

  MultiLayerWaterWavePainter(this.waveAnimationValue, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double waveHeight = 10.0;
    double waveLength = size.width;
    double radius = size.width / 2;
    double centerY = size.height * (1 - progress);

    Paint circlePaint = Paint()..color = Colors.blue.withOpacity(0.5);
    Paint wavePaint1 = Paint()..color = Colors.blue.withOpacity(0.4);
    Paint wavePaint2 = Paint()..color = Colors.blue.withOpacity(0.6);
    Paint wavePaint3 = Paint()..color = Colors.blue.withOpacity(0.8);

    Path wavePath1 = Path();
    Path wavePath2 = Path();
    Path wavePath3 = Path();

    // 第一层波浪
    for (double i = -waveLength / 4; i <= waveLength * 1.25; i++) {
      double dx = i;
      double dy =
          sin((i / waveLength * 2 * pi) + (waveAnimationValue * 2 * pi)) *
                  waveHeight +
              centerY;
      if (i == -waveLength / 4) {
        wavePath1.moveTo(dx, dy);
      } else {
        wavePath1.lineTo(dx, dy);
      }
    }

    // 第二层波浪
    for (double i = -waveLength / 4; i <= waveLength * 1.25; i++) {
      double dx = i;
      double dy = sin((i / waveLength * 2 * pi) +
                  (waveAnimationValue * 2 * pi) +
                  pi / 2) *
              waveHeight +
          centerY;
      if (i == -waveLength / 4) {
        wavePath2.moveTo(dx, dy);
      } else {
        wavePath2.lineTo(dx, dy);
      }
    }

    // 第三层波浪
    for (double i = -waveLength / 4; i <= waveLength * 1.25; i++) {
      double dx = i;
      double dy =
          sin((i / waveLength * 2 * pi) + (waveAnimationValue * 2 * pi) + pi) *
                  waveHeight +
              centerY;
      if (i == -waveLength / 4) {
        wavePath3.moveTo(dx, dy);
      } else {
        wavePath3.lineTo(dx, dy);
      }
    }

    wavePath1.lineTo(size.width * 1.2, size.height);
    wavePath1.lineTo(-waveLength / 3, size.height);
    wavePath1.close();

    wavePath2.lineTo(size.width * 1.4, size.height);
    wavePath2.lineTo(-waveLength / 3, size.height);
    wavePath2.close();

    wavePath3.lineTo(size.width * 1.8, size.height);
    wavePath3.lineTo(-waveLength / 3, size.height);
    wavePath3.close();

    // 绘制圆形背景
    canvas.drawCircle(Offset(radius, radius), radius, circlePaint);

    // 裁剪圆形区域
    canvas.clipPath(Path()
      ..addOval(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius)));

    // 绘制多层波浪
    canvas.drawPath(wavePath1, wavePaint1);
    canvas.drawPath(wavePath2, wavePaint2);
    canvas.drawPath(wavePath3, wavePaint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
