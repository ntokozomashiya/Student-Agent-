import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PolicyTemplateWidget extends StatelessWidget {
  final Map<String, dynamic> template;
  final VoidCallback? onTap;

  const PolicyTemplateWidget({
    Key? key,
    required this.template,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String category = template["category"] as String? ?? "general";
    final Color categoryColor = _getCategoryColor(category);
    final List<String> features =
        (template["features"] as List?)?.cast<String>() ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.outlineLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: _getCategoryIcon(category),
                        color: categoryColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template["name"] as String? ?? "Unnamed Template",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              category.toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 9.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.textDisabledLight,
                      size: 16,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  template["description"] as String? ??
                      "No description available",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (features.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: features
                        .take(3)
                        .map((feature) => _buildFeatureChip(feature))
                        .toList(),
                  ),
                  if (features.length > 3) ...[
                    SizedBox(height: 1.h),
                    Text(
                      '+${features.length - 3} more features',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textDisabledLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String feature) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        feature,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'classroom':
        return AppTheme.primaryLight;
      case 'exam':
        return AppTheme.errorLight;
      case 'study':
        return AppTheme.successColor;
      case 'break':
        return AppTheme.warningColor;
      case 'security':
        return AppTheme.accentColor;
      default:
        return AppTheme.textMediumEmphasisLight;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'classroom':
        return 'school';
      case 'exam':
        return 'quiz';
      case 'study':
        return 'menu_book';
      case 'break':
        return 'free_breakfast';
      case 'security':
        return 'security';
      default:
        return 'policy';
    }
  }
}
