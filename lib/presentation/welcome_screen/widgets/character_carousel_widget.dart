import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async'; // Add this import for Timer

import '../../../core/app_export.dart';

class CharacterCarouselWidget extends StatefulWidget {
  final Function(String) onCharacterTap;

  const CharacterCarouselWidget({
    Key? key,
    required this.onCharacterTap,
  }) : super(key: key);

  @override
  State<CharacterCarouselWidget> createState() =>
      _CharacterCarouselWidgetState();
}

class _CharacterCarouselWidgetState extends State<CharacterCarouselWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Timer _autoScrollTimer;
  int _currentIndex = 0;
  bool _isUserInteracting = false;

  final List<Map<String, dynamic>> _characters = [
    {
      "id": 1,
      "name": "Iron Man",
      "description": "Genius, billionaire, playboy, philanthropist",
      "image":
          "assets/images/ironman.jpg",
      "color": Color(0xFFDC143C),
    },
    {
      "id": 2,
      "name": "Captain America",
      "description": "The First Avenger with unwavering moral compass",
      "image":
          "assets/images/captan america.jpg",
      "color": Color(0xFF1976D2),
    },
    {
      "id": 3,
      "name": "Thor",
      "description": "God of Thunder from Asgard",
      "image":
          "assets/images/Thor.jpg",
      "color": Color(0xFFFFD700),
    },
    {
      "id": 4,
      "name": "Hulk",
      "description": "The incredible green giant with unlimited strength",
      "image":
          "assets/images/Hulk.jpg",
      "color": Color(0xFF4CAF50),
    },
    {
      "id": 5,
      "name": "Black Widow",
      "description": "Master spy and deadly assassin",
      "image":
          "assets/images/blackwido.jpg",
      "color": Color(0xFF212121),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _startAutoScroll();
    _fadeController.forward();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_isUserInteracting && mounted) {
        final nextIndex = (_currentIndex + 1) % _characters.length;
        _pageController.animateToPage(
          nextIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _pageController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        height: 35.h,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _characters.length,
                itemBuilder: (context, index) {
                  final character = _characters[index];
                  final isActive = index == _currentIndex;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: GestureDetector(
                      onTapDown: (_) {
                        _isUserInteracting = true;
                        _scaleController.forward();
                      },
                      onTapUp: (_) {
                        _scaleController.reverse();
                        widget.onCharacterTap(character["name"] as String);
                        Future.delayed(Duration(milliseconds: 100), () {
                          _isUserInteracting = false;
                        });
                      },
                      onTapCancel: () {
                        _scaleController.reverse();
                        _isUserInteracting = false;
                      },
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 1.0,
                          end: 0.95,
                        ).animate(_scaleController),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (character["color"] as Color)
                                    .withValues(alpha: 0.3),
                                blurRadius: isActive ? 20 : 10,
                                offset: Offset(0, isActive ? 8 : 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CustomImageWidget(
                                  imageUrl: character["image"] as String,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4.h,
                                  left: 4.w,
                                  right: 4.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        character["name"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.headlineSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        character["description"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isActive)
                                  Positioned(
                                    top: 2.h,
                                    right: 2.w,
                                    child: Container(
                                      padding: EdgeInsets.all(1.w),
                                      decoration: BoxDecoration(
                                        color: character["color"] as Color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'star',
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _characters.length,
        (index) {
          final isActive = index == _currentIndex;
          final character = _characters[index];

          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            width: isActive ? 8.w : 2.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: isActive
                  ? character["color"] as Color
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.h),
            ),
          );
        },
      ),
    );
  }
}