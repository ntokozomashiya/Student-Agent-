import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PlatformNoticeWidget extends StatelessWidget {
  const PlatformNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS || kIsWeb) {
      return _buildIosNotice();
    }
    return _buildAndroidNotice();
  }

  Widget _buildIosNotice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.warningColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'iOS Limited Functionality',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Due to iOS platform restrictions, some device management features may be limited. Full functionality requires device enrollment through Apple Business Manager or Apple School Manager.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Available features:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          ..._buildFeatureList([
            'Basic app monitoring',
            'Content filtering (limited)',
            'Usage reporting',
            'Educational app recommendations',
          ]),
        ],
      ),
    );
  }

  Widget _buildAndroidNotice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.successColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Android Full Functionality',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Your Android device supports full device management capabilities through Android Device Policy Manager integration.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Available features:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          ..._buildFeatureList([
            'Complete app management',
            'Advanced content filtering',
            'Remote device control',
            'Real-time monitoring',
            'Policy enforcement',
            'Secure communication',
          ]),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList(List<String> features) {
    return features
        .map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 0.5.h, left: 2.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
