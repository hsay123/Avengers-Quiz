import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../data/character_data.dart';
import '../../models/quiz_models.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/character_details_widget.dart';
import './widgets/character_reveal_widget.dart';

class QuizResultsScreen extends StatefulWidget {
  const QuizResultsScreen({Key? key}) : super(key: key);

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  bool _revealComplete = false;
  bool _showDetails = false;

  Map<String, dynamic>? _characterData;
  QuizResult? _quizResult;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _triggerHapticFeedback();
    _loadQuizResult();
  }

  void _loadQuizResult() {
    // Get the quiz result passed as arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is QuizResult) {
        setState(() {
          _quizResult = args;
          _characterData = args.character.toMap();
        });
      } else {
        // Fallback to Iron Man if no result provided (shouldn't happen)
        final fallbackCharacter = CharacterData.getCharacterById('iron_man')!;
        setState(() {
          _characterData = fallbackCharacter.toMap();
        });
      }
    });
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.forward();
  }

  void _triggerHapticFeedback() {
    // Celebration haptic feedback
    HapticFeedback.mediumImpact();
    Future.delayed(Duration(milliseconds: 300), () {
      HapticFeedback.lightImpact();
    });
    Future.delayed(Duration(milliseconds: 600), () {
      HapticFeedback.lightImpact();
    });
  }

  void _onRevealComplete() {
    setState(() {
      _revealComplete = true;
    });

    // Show details after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showDetails = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if character data not loaded yet
    if (_characterData == null) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.primaryColor
                        .withValues(alpha: 0.1 * _backgroundAnimation.value),
                    AppTheme.lightTheme.scaffoldBackgroundColor,
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.05 * _backgroundAnimation.value),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: _revealComplete
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header with back button (only show after reveal)
                    if (_revealComplete)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: CustomIconWidget(
                                iconName: 'arrow_back',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Your Result',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 48), // Balance the back button
                          ],
                        ),
                      ),

                    // Character reveal section
                    CharacterRevealWidget(
                      characterData: _characterData!,
                      onRevealComplete: _onRevealComplete,
                    ),

                    // Character details (show after reveal)
                    if (_showDetails)
                      AnimatedOpacity(
                        opacity: _showDetails ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            CharacterDetailsWidget(
                              characterData: _characterData!,
                            ),
                            SizedBox(height: 2.h),
                            ActionButtonsWidget(
                              characterData: _characterData!,
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),

                    // Loading state before reveal complete
                    if (!_revealComplete)
                      Container(
                        height: 20.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 8.w,
                                height: 8.w,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.primaryColor,
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Analyzing your heroic potential...',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
