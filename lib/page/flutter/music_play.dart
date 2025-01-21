import 'package:flutter/material.dart';

class MusicPlay extends StatefulWidget {
  const MusicPlay({super.key});

  @override
  State<MusicPlay> createState() => _MusicPlayState();
}

class _MusicPlayState extends State<MusicPlay> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween(begin: 0.0, end: 1.0).animate(_rotationController);

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _waveAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          weight: 1.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.0),
          weight: 1.0,
        ),
      ],
    ).animate(_waveController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐播放'),
        backgroundColor: Colors.grey[800], // 设置AppBar背景颜色
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!.withOpacity(0.8), // 顶部颜色
              Colors.grey[800]!.withOpacity(0.8), // 底部颜色
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 300, // 设置容器宽度
            height: 300, // 设置容器高度
            decoration: BoxDecoration(
              color: Colors.grey[850]?.withOpacity(0.5), // 设置容器背景颜色为半透明深灰色
              borderRadius: BorderRadius.circular(150), // 设置容器圆角
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 水波纹动画
                AnimatedWave(controller: _waveAnimation),
                // 封面图旋转动画
                RotationTransition(
                  turns: _rotationAnimation,
                  child: ScaleTransition(
                    scale: _waveAnimation, // 图片缩放比例跟随水波纹动画值变化
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/cover.jpg', // 替换为你的封面图路径
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover, // 确保图片覆盖整个圆形区域
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedWave extends StatefulWidget {
  final Animation<double> controller;

  const AnimatedWave({required this.controller, super.key});

  @override
  _AnimatedWaveState createState() => _AnimatedWaveState();
}

class _AnimatedWaveState extends State<AnimatedWave> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(widget.controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 绘制多个同心圆
    for (int i = 0; i < 5; i++) {
      final baseRadius = 50.0 + (i * 20);
      final radius = baseRadius + (animationValue * 100);
      final opacity = (1 - (i / 5)) * 0.4; // 透明度逐渐减小

      final paint = Paint()
        ..color = Colors.blue.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
