import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _bubbleController;
  late AnimationController _fishController;
  late Animation<double> _waveAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _fishAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fishController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.linear));

    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    _fishAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fishController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _waveController.repeat();
    _bubbleController.repeat(reverse: true);
    _fishController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
    _fishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Waves
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  animation: _waveAnimation.value,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                size: Size.infinite,
              );
            },
          ),

          // Animated Bubbles
          AnimatedBuilder(
            animation: _bubbleAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: BubblePainter(
                  animation: _bubbleAnimation.value,
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.1),
                ),
                size: Size.infinite,
              );
            },
          ),

          // Animated Fish
          AnimatedBuilder(
            animation: _fishAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: FishPainter(
                  animation: _fishAnimation.value,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
                size: Size.infinite,
              );
            },
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height * 0.8);

    for (double x = 0; x <= size.width; x += 1) {
      final y =
          size.height * 0.8 +
          waveHeight * math.sin((x / waveLength) * 2 * math.pi + animation);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BubblePainter extends CustomPainter {
  final double animation;
  final Color color;

  BubblePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create multiple bubbles
    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i + (size.width / 16);
      final y =
          size.height * 0.2 + (size.height * 0.6) * ((animation + i * 0.1) % 1);
      final radius = 5.0 + (3.0 * math.sin(animation * 2 * math.pi + i));

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FishPainter extends CustomPainter {
  final double animation;
  final Color color;

  FishPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create swimming fish
    final fishX = size.width * 0.1 + (size.width * 0.8) * animation;
    final fishY = size.height * 0.3 + 20 * math.sin(animation * 4 * math.pi);

    _drawFish(canvas, paint, fishX, fishY, animation);
  }

  void _drawFish(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double animation,
  ) {
    final path = Path();

    // Fish body
    path.moveTo(x, y);
    path.quadraticBezierTo(x + 20, y - 10, x + 40, y);
    path.quadraticBezierTo(x + 20, y + 10, x, y);

    // Fish tail
    path.moveTo(x + 40, y);
    path.lineTo(x + 50, y - 5);
    path.lineTo(x + 50, y + 5);
    path.close();

    canvas.drawPath(path, paint);

    // Fish eye
    canvas.drawCircle(Offset(x + 15, y - 3), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
