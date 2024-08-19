// ignore_for_file: use_super_parameters

import 'dart:math';

import 'package:flutter/material.dart';

class WaveProgressBarPainter extends CustomPainter {
  final double progress; // 进度 0.0 到 1.0
  final double wavePhase; // 波浪相位，用于控制波浪动画

  WaveProgressBarPainter(this.progress, this.wavePhase);

  @override
  void paint(Canvas canvas, Size size) {
    // 设置矩形和波浪的颜色
    Paint backgroundPaint = Paint()
      ..color = Colors.blue // 背景颜色
      ..style = PaintingStyle.fill;

    Paint wavePaint = Paint()
      ..color = Colors.lightBlue // 波浪颜色
      ..style = PaintingStyle.fill;

    // 创建矩形路径
    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 300,
        height: size.height);

    // 绘制矩形背景
    canvas.drawRect(rect, backgroundPaint);

    // 创建波浪路径
    Path wavePath = Path();
    double waveHeight = 20.0; // 波浪高度
    double waveLength = 100.0; // 波长

    // 计算进度条高度，从高度的一半开始
    double progressHeight = size.height / 2 * (1 - progress);

    wavePath.moveTo(rect.left - wavePhase, rect.bottom);
    for (double x = rect.left - wavePhase;
        x <= rect.right + waveLength;
        x += waveLength) {
      wavePath.quadraticBezierTo(
        x + waveLength / 4,
        rect.bottom - waveHeight + progressHeight,
        x + waveLength / 2,
        rect.bottom + progressHeight,
      );
    }
    wavePath.lineTo(rect.right, rect.bottom);
    wavePath.lineTo(rect.right, rect.top);
    wavePath.lineTo(rect.left, rect.top);
    wavePath.close();

    // 使用裁剪来限制波浪的绘制区域
    canvas.clipRect(rect);

    // 绘制波浪
    canvas.drawPath(wavePath, wavePaint);

    // 如果需要在波浪上显示进度文本
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: "${(progress * 100).toInt()}%",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    Offset textOffset = Offset(rect.center.dx - textPainter.width / 2,
        rect.center.dy - textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaveProgressBar extends StatefulWidget {
  final double progress;

  WaveProgressBar({required this.progress});

  @override
  _WaveProgressBarState createState() => _WaveProgressBarState();
}

class _WaveProgressBarState extends State<WaveProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  double _wavePhase = 0.0;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();

    // 初始化波浪动画控制器，动画速度减慢
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // 调整持续时间让波浪更缓慢
    )..repeat(); // 不断重复动画

    // 波浪动画
    _waveController.addListener(() {
      setState(() {
        _wavePhase += 5; // 控制波浪相位的移动速度，调慢波浪移动
        if (_wavePhase > 100) {
          _wavePhase -= 100;
        }
      });
    });

    // 初始化进度条动画控制器
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // 控制进度条变化的动画时长
    );

    // 进度动画
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(_progressController)
      ..addListener(() {
        setState(() {
          _currentProgress = _progressAnimation.value;
        });
      });

    // 开始进度条动画
    _progressController.forward();
  }

  @override
  void didUpdateWidget(WaveProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      // 更新进度条动画的目标值
      _progressAnimation = Tween<double>(
        begin: _currentProgress,
        end: widget.progress,
      ).animate(_progressController)
        ..addListener(() {
          setState(() {
            _currentProgress = _progressAnimation.value;
          });
        });

      // 重新开始进度条动画
      _progressController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveProgressBarPainter(_currentProgress, _wavePhase),
      size: Size(300, 200),
    );
  }
}
