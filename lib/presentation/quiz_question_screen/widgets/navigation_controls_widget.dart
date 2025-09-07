import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationControlsWidget extends StatelessWidget {
  final bool canGoBack;
  final bool canGoNext;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool isLastQuestion;

  const NavigationControlsWidget({
    Key? key,
    required this.canGoBack,
    required this.canGoNext,
    this.onBack,
    this.onNext,
    this.isLastQuestion = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back Button
            canGoBack
                ? Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onBack,
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : Expanded(child: SizedBox()),

            SizedBox(width: canGoBack ? 4.w : 0),

            // Next/Finish Button
            Expanded(
              flex: canGoBack ? 1 : 2,
              child: ElevatedButton.icon(
                onPressed: canGoNext ? onNext : null,
                icon: CustomIconWidget(
                  iconName: isLastQuestion ? 'check' : 'arrow_forward',
                  color: canGoNext
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                  size: 20,
                ),
                label: Text(isLastQuestion ? 'Finish Quiz' : 'Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canGoNext
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  foregroundColor: canGoNext
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: canGoNext ? 2 : 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
