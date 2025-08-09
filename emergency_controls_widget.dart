import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyControlsWidget extends StatelessWidget {
  final Map<String, dynamic> deviceData;
  final VoidCallback? onEmergencyUnlock;
  final VoidCallback? onFactoryReset;
  final VoidCallback? onRemoveDevice;

  const EmergencyControlsWidget({
    Key? key,
    required this.deviceData,
    this.onEmergencyUnlock,
    this.onFactoryReset,
    this.onRemoveDevice,
  }) : super(key: key);

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback? onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.errorLight,
            ),
          ),
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Confirm',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOnline =
        (deviceData['status'] as String? ?? 'offline').toLowerCase() ==
            'online';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.errorLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.errorLight.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.errorLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Controls',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.errorLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Use these controls only in emergency situations. These actions cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          Column(
            children: [
              _buildEmergencyButton(
                context: context,
                icon: 'lock_open',
                label: 'Emergency Unlock',
                description:
                    'Immediately unlock device bypassing all restrictions',
                isEnabled: isOnline,
                onTap: () => _showConfirmationDialog(
                  context,
                  'Emergency Unlock',
                  'This will immediately unlock the device and bypass all current restrictions. This action will be logged for audit purposes.',
                  onEmergencyUnlock,
                ),
              ),
              SizedBox(height: 2.h),
              _buildEmergencyButton(
                context: context,
                icon: 'settings_backup_restore',
                label: 'Factory Reset',
                description:
                    'Completely wipe device and restore to factory settings',
                isEnabled: isOnline,
                onTap: () => _showConfirmationDialog(
                  context,
                  'Factory Reset',
                  'This will completely erase all data on the device and restore it to factory settings. All user data, apps, and settings will be permanently lost.',
                  onFactoryReset,
                ),
              ),
              SizedBox(height: 2.h),
              _buildEmergencyButton(
                context: context,
                icon: 'remove_circle',
                label: 'Remove Device',
                description: 'Remove device from management system permanently',
                isEnabled: true,
                onTap: () => _showConfirmationDialog(
                  context,
                  'Remove Device',
                  'This will permanently remove the device from the management system. The device will no longer be monitored or controlled.',
                  onRemoveDevice,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton({
    required BuildContext context,
    required String icon,
    required String label,
    required String description,
    required bool isEnabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.errorLight.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEnabled
                ? AppTheme.errorLight.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppTheme.errorLight.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isEnabled
                    ? AppTheme.errorLight
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isEnabled
                          ? AppTheme.errorLight
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isEnabled
                          ? AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7)
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isEnabled)
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.errorLight.withValues(alpha: 0.6),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
