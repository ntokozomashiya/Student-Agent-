import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ActivityItemWidget({
    super.key,
    required this.activity,
    this.onTap,
    this.onLongPress,
  });

  Color _getActivityColor() {
    final action = (activity['action'] as String).toLowerCase();
    if (action.contains('lock') || action.contains('block')) {
      return AppTheme.warningColor;
    } else if (action.contains('unlock') || action.contains('allow')) {
      return AppTheme.successColor;
    } else if (action.contains('violation') || action.contains('alert')) {
      return AppTheme.errorLight;
    }
    return AppTheme.primaryLight;
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityColor = _getActivityColor();
    final timestamp = activity['timestamp'] as DateTime;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.outlineLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: activityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getActivityIcon(),
                  color: activityColor,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['deviceName'] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    activity['action'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getTimeAgo(timestamp),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
                if (activity['priority'] == 'high') ...[
                  SizedBox(height: 0.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HIGH',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getActivityIcon() {
    final action = (activity['action'] as String).toLowerCase();
    if (action.contains('lock')) {
      return 'lock';
    } else if (action.contains('unlock')) {
      return 'lock_open';
    } else if (action.contains('block')) {
      return 'block';
    } else if (action.contains('allow')) {
      return 'check_circle';
    } else if (action.contains('violation')) {
      return 'warning';
    } else if (action.contains('message')) {
      return 'message';
    }
    return 'info';
  }
}
