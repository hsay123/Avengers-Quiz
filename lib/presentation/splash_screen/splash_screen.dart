import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundAnimation;

  bool _isLoading = true;
  double _loadingProgress = 0.0;
  String _loadingText = 'Initializing Avengers...';
  bool _showRetryButton = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSplashSequence() async {
    try {
      // Hide status bar for full-screen experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      // Start background animation
      _backgroundAnimationController.forward();

      // Delay before starting logo animation
      await Future.delayed(const Duration(milliseconds: 500));

      // Start logo animation
      _logoAnimationController.forward();

      // Simulate loading process
      await _simulateLoading();

      // Navigate to welcome screen after successful loading
      if (mounted) {
        _navigateToWelcome();
      }
    } catch (e) {
      _handleLoadingError();
    }
  }

  Future<void> _simulateLoading() async {
    final loadingSteps = [
      {'text': 'Loading quiz questions...', 'duration': 800},
      {'text': 'Caching character avatars...', 'duration': 1000},
      {'text': 'Initializing animation controllers...', 'duration': 600},
      {'text': 'Preparing welcome screen...', 'duration': 700},
    ];

    for (int i = 0; i < loadingSteps.length; i++) {
      if (!mounted) return;

      setState(() {
        _loadingText = loadingSteps[i]['text'] as String;
        _loadingProgress = (i + 1) / loadingSteps.length;
      });

      await Future.delayed(
          Duration(milliseconds: loadingSteps[i]['duration'] as int));
    }

    // Final loading completion
    if (mounted) {
      setState(() {
        _loadingProgress = 1.0;
        _loadingText = 'Ready to discover your inner Avenger!';
      });

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _handleLoadingError() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _showRetryButton = true;
        _loadingText = 'Something went wrong. Please try again.';
      });
    }
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _showRetryButton = false;
      _loadingProgress = 0.0;
    });
    _startSplashSequence();
  }

  void _navigateToWelcome() {
    // Restore system UI before navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Navigator.pushReplacementNamed(
      context,
      '/welcome-screen',
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF0D47A1),
                    const Color(0xFF1565C0),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF1565C0),
                    const Color(0xFFDC143C),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFDC143C),
                    const Color(0xFFB71C1C),
                    _backgroundAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildLogoSection(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildLoadingSection(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_logoScaleAnimation, _logoFadeAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Opacity(
              opacity: _logoFadeAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avengers Logo with Lottie Animation
                  Container(
                    width: 60.w,
                    height: 25.h,
                    child: Lottie.network(
                      'https://lottie.host/4d3c5c5e-8f2a-4c5a-9b3a-2f1e8d7c6b5a/superhero-logo.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: _logoAnimationController.isAnimating,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackLogo();
                      },
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // App Title
                  Text(
                    'AVENGERS',
                    style:
                        AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'PERSONALITY QUIZ',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      width: 60.w,
      height: 25.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.tertiary,
            AppTheme.lightTheme.colorScheme.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'shield',
          color: Colors.white,
          size: 15.w,
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading) ...[
            // Loading Progress Bar
            Container(
              width: double.infinity,
              height: 0.8.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _loadingProgress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Loading Text
            Text(
              _loadingText,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 1.h),
            // Loading Percentage
            Text(
              '${(_loadingProgress * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          if (_showRetryButton) ...[
            Text(
              _loadingText,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _retryLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'refresh',
                    color: Colors.black,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Retry',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
