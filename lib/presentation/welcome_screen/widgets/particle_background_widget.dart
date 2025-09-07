import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class ParticleBackgroundWidget extends StatefulWidget {
  final Widget child;

  const ParticleBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ParticleBackgroundWidget> createState() =>
      _ParticleBackgroundWidgetState();
}

class _ParticleBackgroundWidgetState extends State<ParticleBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Particle> _particles = [];
  final int _particleCount = 50;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    );

    _initializeParticles();
    _animationController.repeat();
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble() * 100.w,
          y: random.nextDouble() * 100.h,
          size: random.nextDouble() * 4 + 1,
          speed: random.nextDouble() * 2 + 0.5,
          opacity: random.nextDouble() * 0.5 + 0.1,
          color: _getRandomParticleColor(random),
        ),
      );
    }
  }

  Color _getRandomParticleColor(math.Random random) {
    final colors = [
      Color(0xFF1976D2).withValues(alpha: 0.3),
      Color(0xFFDC143C).withValues(alpha: 0.3),
      Color(0xFFFFD700).withValues(alpha: 0.3),
      Color(0xFF4CAF50).withValues(alpha: 0.3),
      Color(0xFF9C27B0).withValues(alpha: 0.3),
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D47A1).withValues(alpha: 0.1),
                Color(0xFF1976D2).withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(_particles, _animationController.value),
              size: Size(100.w, 100.h),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position
      particle.y -= particle.speed;
      if (particle.y < -10) {
        particle.y = size.height + 10;
        particle.x = math.Random().nextDouble() * size.width;
      }

      // Create paint for particle
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      // Draw particle with subtle glow effect
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * (1 + math.sin(animationValue * 2 * math.pi) * 0.2),
        paint,
      );

      // Add subtle glow
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size);

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
