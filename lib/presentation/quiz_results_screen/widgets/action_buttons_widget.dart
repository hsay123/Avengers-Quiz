import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatefulWidget {
  final Map<String, dynamic> characterData;

  const ActionButtonsWidget({
    Key? key,
    required this.characterData,
  }) : super(key: key);

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _animateButton() async {
    await _bounceController.forward();
    await _bounceController.reverse();
  }

  void _shareResult() async {
    _animateButton();

    final String shareText = '''
🦸‍♂️ I just discovered my Marvel personality!

I'm most like ${widget.characterData['name']}!

${widget.characterData['description']}

Take the Avengers Personality Quiz and find out which hero you are! 🚀

#AvengersQuiz #Marvel #PersonalityTest
    ''';

    try {
      await Share.share(
        shareText,
        subject: 'My Avengers Personality Result',
      );
    } catch (e) {
      // Handle share error gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to share at the moment'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _retakeQuiz() {
    _animateButton();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome-screen',
      (route) => false,
    );
  }

  void _viewAllCharacters() {
    _animateButton();
    Navigator.pushNamed(context, '/character-gallery-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Share button (prominent)
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: Container(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton.icon(
                    onPressed: _shareResult,
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24,
                    ),
                    label: Text(
                      'Share My Result',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      elevation: 4,
                      shadowColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),

          // Secondary action buttons
          Row(
            children: [
              // Retake quiz button
              Expanded(
                child: Container(
                  height: 6.h,
                  child: OutlinedButton.icon(
                    onPressed: _retakeQuiz,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    label: Text(
                      'Retake Quiz',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // View all characters button
              Expanded(
                child: Container(
                  height: 6.h,
                  child: OutlinedButton.icon(
                    onPressed: _viewAllCharacters,
                    icon: CustomIconWidget(
                      iconName: 'group',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 20,
                    ),
                    label: Text(
                      'All Heroes',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Back to home button
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/welcome-screen',
                (route) => false,
              );
            },
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            label: Text(
              'Back to Home',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
