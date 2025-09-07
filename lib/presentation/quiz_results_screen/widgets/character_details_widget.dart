import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CharacterDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> characterData;

  const CharacterDetailsWidget({
    Key? key,
    required this.characterData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> traits =
        (characterData['traits'] as List).cast<String>();
    final List<String> strengths =
        (characterData['strengths'] as List).cast<String>();
    final List<String> funFacts =
        (characterData['funFacts'] as List).cast<String>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personality description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Personality Match',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  characterData['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Character traits
          _buildSection(
            title: 'Character Traits',
            items: traits,
            icon: 'psychology',
            color: AppTheme.lightTheme.colorScheme.secondary,
          ),

          SizedBox(height: 2.h),

          // Strengths
          _buildSection(
            title: 'Your Strengths',
            items: strengths,
            icon: 'star',
            color: AppTheme.lightTheme.colorScheme.tertiary,
          ),

          SizedBox(height: 2.h),

          // Fun facts
          _buildSection(
            title: 'Fun Facts',
            items: funFacts,
            icon: 'lightbulb',
            color: AppTheme.lightTheme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required String icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          ...items
              .map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: EdgeInsets.only(top: 1.h, right: 3.w),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
