import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final Map<String, dynamic> deviceData;
  final VoidCallback? onLockToggle;
  final VoidCallback? onSendMessage;
  final VoidCallback? onLocate;
  final VoidCallback? onRestart;
  final VoidCallback? onScreenshot;

  const QuickActionsWidget({
    Key? key,
    required this.deviceData,
    this.onLockToggle,
    this.onSendMessage,
    this.onLocate,
    this.onRestart,
    this.onScreenshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLocked = deviceData['isLocked'] as bool? ?? false;
    final bool isOnline =
        (deviceData['status'] as String? ?? 'offline').toLowerCase() ==
            'online';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: isLocked ? 'lock_open' : 'lock',
                  label: isLocked ? 'Unlock' : 'Lock',
                  color:
                      isLocked ? AppTheme.successColor : AppTheme.warningColor,
                  onTap: isOnline ? onLockToggle : null,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  icon: 'message',
                  label: 'Message',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onTap: isOnline ? onSendMessage : null,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  icon: 'location_on',
                  label: 'Locate',
                  color: AppTheme.accentColor,
                  onTap: onLocate,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: 'restart_alt',
                  label: 'Restart',
                  color: AppTheme.warningColor,
                  onTap: isOnline ? onRestart : null,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  icon: 'screenshot',
                  label: 'Screenshot',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: isOnline ? onScreenshot : null,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(child: Container()), // Empty space for alignment
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    final bool isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEnabled
                ? color.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isEnabled
                  ? color
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.4),
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isEnabled
                    ? color
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
