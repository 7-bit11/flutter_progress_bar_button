// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';

class CircularAnimatedProgressBar extends StatefulWidget {
  /// 大小
  final double size;

  /// 进度
  final double progress;

  /// 是否显示进度
  final bool isShowProgress;

  /// 是否显示进度的样式
  final TextStyle showProgressTextStyle;

  /// 波浪高度
  final double waveHeight;

  /// 动画曲线
  final Curve curve;

  /// 波浪颜色&波浪层数
  /// 默认为蓝色
  /// 2、4、6 排序显示为 最上层为 6 、4 、2
  late List<Color> colorsWave;

  /// 构造方法
  CircularAnimatedProgressBar(
      {super.key,
      this.size = 150.0,
      this.progress = .2,
      this.isShowProgress = true,
      this.curve = Curves.linear,
      this.waveHeight = 12,

      /// 默认为蓝色
      /// 2、4、6 排序显示为 最上层为 6 、4 、2
      this.colorsWave = const [
        Color(0x1A2196f3),
        Color(0x662196f3),
        Color(0xCC2196f3)
      ],
      this.showProgressTextStyle = const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)})
      : assert(progress >= 0.0 && progress <= 1.0,
            "Progress must be less than 1 and greater than 0"),
        assert(size > 0.0, "The size must be greater than 0");

  @override
  _CircularAnimatedProgressBarState createState() =>
      _CircularAnimatedProgressBarState();
}

class _CircularAnimatedProgressBarState
    extends State<CircularAnimatedProgressBar> with TickerProviderStateMixin {
  /// 进度动画控制器
  late AnimationController _progressController;

  /// 波浪动画控制器
  late AnimationController _waveController;

  /// 进度动画
  late Animation<double> _progressAnimation;

  /// 波浪动画
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
      CurvedAnimation(parent: _progressController, curve: widget.curve),
    );

    // 水波纹动画控制器，保持循环
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // 循环执行水波纹动画
  }

  @override
  void didUpdateWidget(CircularAnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _oldProgress = oldWidget.progress;
      _progressAnimation =
          Tween<double>(begin: _oldProgress, end: widget.progress).animate(
        CurvedAnimation(parent: _progressController, curve: widget.curve),
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
                      waveAnimationValue: _waveController.value,
                      progress: _progressAnimation.value,
                      waveHeight: widget.waveHeight,
                      colorsWave: widget.colorsWave),
                )),
            widget.isShowProgress
                ? Text('${(_progressAnimation.value * 100).toInt()}%',
                    style: widget.showProgressTextStyle)
                : const SizedBox()
          ],
        );
      },
    );
  }
}

class MultiLayerWaterWavePainter extends CustomPainter {
  /// 水波纹动画值
  final double waveAnimationValue;

  /// 进度
  final double progress;

  /// 波浪高度
  final double waveHeight;

  /// 波浪颜色&波浪层数
  /// 默认为蓝色
  /// 2、4、6 排序显示为 最上层为 6 、4 、2
  final List<Color> colorsWave;
  MultiLayerWaterWavePainter(
      {required this.waveAnimationValue,
      required this.progress,
      required this.waveHeight,
      required this.colorsWave});

  @override
  void paint(Canvas canvas, Size size) {
    double waveLength = size.width;
    double radius = size.width / 2;
    double centerY = size.height * (1 - progress);

    Paint circlePaint = Paint()..color = Colors.blue.withOpacity(0.5);
    Paint wavePaint1 = Paint()..color = Colors.blue.withOpacity(0.4);
    Paint wavePaint2 = Paint()..color = Colors.blue.withOpacity(0.6);
    Paint wavePaint3 = Paint()..color = Colors.blue.withOpacity(0.8);
    Paint wavePaint4 = Paint()..color = Colors.red.withOpacity(0.8);
    Path wavePath1 = Path();
    Path wavePath2 = Path();
    Path wavePath3 = Path();
    Path wavePath4 = Path();
    // 第一层波浪
    for (double i = -waveLength / 4; i <= waveLength * 1.5; i++) {
      double dx = i;
      double dy =
          sin((i / waveLength * 2.5 * pi) + (waveAnimationValue * 2 * pi)) *
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
      double dy = sin((i / waveLength * 1.5 * pi) +
                  (waveAnimationValue * 2 * pi) +
                  pi) *
              waveHeight +
          centerY;
      if (i == -waveLength / 4) {
        wavePath3.moveTo(dx, dy);
      } else {
        wavePath3.lineTo(dx, dy);
      }
    }

    // 第三层波浪
    for (double i = -waveLength / 4; i <= waveLength * 1.25; i++) {
      double dx = i;
      double dy = sin((i / waveLength * 1.5 * pi) +
                  (waveAnimationValue * 2 * pi) +
                  pi) *
              waveHeight +
          centerY;
      if (i == -waveLength / 4) {
        wavePath4.moveTo(dx, dy);
      } else {
        wavePath4.lineTo(dx, dy);
      }
    }

    wavePath1.lineTo(size.width * 3, size.height);
    wavePath1.lineTo(-waveLength / 4, size.height);
    wavePath1.close();

    wavePath2.lineTo(size.width * 3, size.height);
    wavePath2.lineTo(-waveLength / 4, size.height);
    wavePath2.close();

    wavePath3.lineTo(size.width * 3, size.height);
    wavePath3.lineTo(-waveLength / 4, size.height);
    wavePath3.close();

    wavePath4.lineTo(size.width * 3, size.height);
    wavePath4.lineTo(-waveLength / 4, size.height);
    wavePath4.close();

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

    canvas.drawPath(wavePath4, wavePaint4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
