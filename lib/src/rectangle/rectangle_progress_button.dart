// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_button/src/enum/position_enum.dart';

class RectangleAnimatedProgressBar extends StatefulWidget {
  /// 大小
  final double width;
  final double height;

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

  /// 背景颜色
  late Color backgroundColor;

  /// 点击事件
  late void Function()? onPressed;

  /// 圆角
  final double circular;

  ///
  final PositionEnum enumPosition;

  /// 完成后的显示
  final String completedText;

  /// 构造方法
  RectangleAnimatedProgressBar(
      {super.key,
      this.width = 150.0,
      this.height = 60.0,
      this.progress = .2,
      this.isShowProgress = true,
      this.curve = Curves.linear,
      this.onPressed,
      this.waveHeight = 12,
      this.backgroundColor = const Color(0x662196f3),
      this.circular = 5.0,
      this.completedText = 'Completed',
      this.enumPosition = PositionEnum.bottom,

      /// 波浪颜色&波浪层数
      /// 默认为蓝色
      /// 2、4、6 排序显示为 最上层为 6 、4 、2
      this.colorsWave = const [
        Color(0x4D2196f3),
        Color(0x662196f3),
        Color(0xCC2196f3),
      ],
      this.showProgressTextStyle = const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)})
      : assert(progress >= 0.0 && progress <= 1.0,
            "Progress must be less than 1 and greater than 0"),
        assert(width > 0.0, "The width must be greater than 0"),
        assert(height > 0.0, "The height must be greater than 0"),
        assert(colorsWave.isNotEmpty && colorsWave.length <= 3,
            "ColorsWave must be not empty and length less than 3");

  @override
  _RectangleAnimatedProgressBarState createState() =>
      _RectangleAnimatedProgressBarState();
}

class _RectangleAnimatedProgressBarState
    extends State<RectangleAnimatedProgressBar> with TickerProviderStateMixin {
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
    // if (widget.enumPosition == PositionEnum.left) {
    //   widget.colorsWave = widget.colorsWave.reversed.toList();
    // }
    _oldProgress = widget.progress;

    // 进度动画控制器
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
  void didUpdateWidget(RectangleAnimatedProgressBar oldWidget) {
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
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: Listenable.merge([_progressController, _waveController]),
        builder: (context, child) {
          bool isCompleted = _progressAnimation.value >= 1.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.circular),
                child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: CustomPaint(
                      painter: RectangleMultiLayerWaterWavePainter(
                          waveAnimationValue: _waveController.value,
                          progress: _progressAnimation.value,
                          waveHeight: widget.waveHeight,
                          colorsWave: widget.colorsWave,
                          enumPosition: widget.enumPosition,
                          backgroundColor: widget.backgroundColor),
                    )),
              ),
              isCompleted
                  ? ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _progressController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Text(widget.completedText,
                          style: widget.showProgressTextStyle),
                    )
                  : Text('${(_progressAnimation.value * 100).toInt()}%',
                      style: widget.showProgressTextStyle),
            ],
          );
        },
      ),
    );
  }
}

class RectangleMultiLayerWaterWavePainter extends CustomPainter {
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

  /// 背景颜色
  final Color backgroundColor;
  final PositionEnum enumPosition;

  RectangleMultiLayerWaterWavePainter(
      {required this.waveAnimationValue,
      required this.progress,
      required this.waveHeight,
      required this.colorsWave,
      required this.backgroundColor,
      required this.enumPosition});
  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = backgroundColor;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    List<Paint> wavePaints = [];
    List<Path> paths = [];
    double dynamicWaveHeight = waveHeight * progress;
    double sindy = 2.5;
    // 绘制矩形背景
    canvas.drawRect(rect, circlePaint);
    if (progress == 1) {
      dynamicWaveHeight = 0;
    } else if (progress >= .6) {
      dynamicWaveHeight = waveHeight * .6;
    }

    /// 波浪画笔
    for (var index = 0; index < colorsWave.length; index++) {
      wavePaints.add(Paint()..color = colorsWave[index]);
      paths.add(Path());
    }
    if (paths.length == 1) {
      sindy = 1.5;
    } else if (paths.length == 2) {
      sindy = 2.0;
    }
    if (enumPosition == PositionEnum.bottom) {
      double waveLength = size.width;
      double centerY = size.height * (1 - progress);

      /// 绘制波浪
      for (var index = 0; index < paths.length; index++) {
        for (double i = -waveLength / 4; i <= waveLength * 1.5; i++) {
          double dx = i;
          double dy;
          dy = sin((i / waveLength * sindy * pi) +
                      (waveAnimationValue * 2 * pi)) *
                  dynamicWaveHeight +
              centerY;
          if (index == 1) {
            dy = sin((i / waveLength * sindy * pi) +
                        (waveAnimationValue * 2 * pi) +
                        pi / 2) *
                    dynamicWaveHeight +
                centerY;
          } else if (index == 2) {
            dy = sin((i / waveLength * sindy * pi) +
                        (waveAnimationValue * 2 * pi) +
                        pi) *
                    dynamicWaveHeight +
                centerY;
          }
          if (i == -waveLength / 4) {
            paths[index].moveTo(dx, dy);
          } else {
            paths[index].lineTo(dx, dy);
          }
        }
        sindy -= .5;
      }
      for (var index = 0; index < paths.length; index++) {
        paths[index].lineTo(size.width * 3, size.height);
        paths[index].lineTo(-waveLength / 4, size.height);
        paths[index].close();
      }
    } else if (enumPosition == PositionEnum.left) {
      double waveLength = size.height; // 将波浪长度改为根据高度计算
      double centerX = size.width * progress; // 从左往右增长
      // 动态调整波浪高度，基于进度值
      // 绘制波浪
      for (var index = 0; index < paths.length; index++) {
        for (double i = -waveLength / 4; i <= waveLength * 1.5; i++) {
          double dy = i;
          double dx;
          dx = sin((i / waveLength * sindy * pi) +
                      (waveAnimationValue * 2 * pi)) *
                  dynamicWaveHeight +
              centerX;

          if (index == 1) {
            dx = sin((i / waveLength * sindy * pi) +
                        (waveAnimationValue * 2 * pi) +
                        pi / 2) *
                    dynamicWaveHeight +
                centerX;
          } else if (index == 2) {
            dx = sin((i / waveLength * sindy * pi) +
                        (waveAnimationValue * 2 * pi) +
                        pi) *
                    dynamicWaveHeight +
                centerX;
          }
          if (i == -waveLength / 4) {
            paths[index].moveTo(dx, dy);
          } else {
            paths[index].lineTo(dx, dy);
          }
        }
        sindy -= .5;
      }
      for (var index = 0; index < paths.length; index++) {
        paths[index].lineTo(0, size.height * 3);
        paths[index].lineTo(0, -waveLength / 4);
        paths[index].close();
      }
    } else if (enumPosition == PositionEnum.right) {
      double waveLength = size.height; // 将波浪长度改为根据高度计算
      double centerX = size.width * (1 - progress); // 从右边开始计算

      // 动态调整波浪高度，基于进度值

      // 绘制波浪
      for (var index = 0; index < paths.length; index++) {
        for (double i = -waveLength / 4; i <= waveLength * 1.5; i++) {
          double dy = i;
          double dx;

          dx = sin((i / waveLength * sindy * pi) +
                      (waveAnimationValue * 2 * pi)) *
                  dynamicWaveHeight + // 使用动态波浪高度
              centerX;

          if (index == 1) {
            dx = sin((i / waveLength * sindy * pi) +
                        (waveAnimationValue * 2 * pi) +
                        pi / 2) *
                    dynamicWaveHeight + // 使用动态波浪高度
                centerX;
          } else if (index == 2) {
            dx = sin((i / waveLength * sindy * pi) +
                        (waveAnimationValue * 2 * pi) +
                        pi) *
                    dynamicWaveHeight + // 使用动态波浪高度
                centerX;
          }

          if (i == -waveLength / 4) {
            paths[index].moveTo(dx, dy);
          } else {
            paths[index].lineTo(dx, dy);
          }
        }
        sindy -= .5;
      }

      for (var index = 0; index < paths.length; index++) {
        paths[index].lineTo(size.width, size.height * 3);
        paths[index].lineTo(size.width, -waveLength / 4);
        paths[index].close();
      }

      canvas.save();
      canvas.clipRect(rect);

      // 绘制多层波浪
      for (var i = 0; i < wavePaints.length; i++) {
        canvas.drawPath(paths[i], wavePaints[i]);
      }

      canvas.restore();
    }

    canvas.save();
    canvas.clipRect(rect);
    // 绘制多层波浪
    for (var i = 0; i < wavePaints.length; i++) {
      canvas.drawPath(paths[i], wavePaints[i]);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
