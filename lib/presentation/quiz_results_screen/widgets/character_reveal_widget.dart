import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CharacterRevealWidget extends StatefulWidget {
  final Map<String, dynamic> characterData;
  final VoidCallback onRevealComplete;

  const CharacterRevealWidget({
    Key? key,
    required this.characterData,
    required this.onRevealComplete,
  }) : super(key: key);

  @override
  State<CharacterRevealWidget> createState() => _CharacterRevealWidgetState();
}

class _CharacterRevealWidgetState extends State<CharacterRevealWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showConfetti = false;
  bool _showCharacter = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRevealSequence();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startRevealSequence() async {
    // Start confetti first
    setState(() => _showConfetti = true);

    // Wait a bit then show character
    await Future.delayed(Duration(milliseconds: 500));
    setState(() => _showCharacter = true);

    // Start animations
    _fadeController.forward();
    await Future.delayed(Duration(milliseconds: 200));
    _scaleController.forward();

    // Complete reveal after animations
    await Future.delayed(Duration(milliseconds: 1000));
    widget.onRevealComplete();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti animation
          if (_showConfetti)
            Positioned.fill(
              child: Lottie.asset(
                'assets/animations/confetti.json',
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),

          // Character reveal
          if (_showCharacter)
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Character avatar
                        Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: CustomImageWidget(
                              imageUrl:
                                  widget.characterData['avatar'] as String,
                              width: 35.w,
                              height: 35.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Character name
                        Text(
                          widget.characterData['name'] as String,
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 1.h),

                        // Subtitle
                        Text(
                          'You are most like...',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
