import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceCardWidget extends StatelessWidget {
  final Map<String, dynamic> device;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(String action) onSwipeAction;
  final bool isSelected;

  const DeviceCardWidget({
    Key? key,
    required this.device,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeAction,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(device["id"].toString()),
      background: _buildSwipeBackground(context, isLeftSwipe: false),
      secondaryBackground: _buildSwipeBackground(context, isLeftSwipe: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _showQuickActions(context);
        } else {
          onSwipeAction('remove');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 2)
              : Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (isSelected)
                    Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                device["deviceName"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusIndicator(),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          device["studentName"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.textMediumEmphasisLight,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              _formatLastSeen(device["lastSeen"] as DateTime),
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            const Spacer(),
                            _buildBatteryIndicator(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final status = device["status"] as String;
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'online':
        statusColor = AppTheme.successColor;
        statusIcon = Icons.circle;
        break;
      case 'warning':
        statusColor = AppTheme.warningColor;
        statusIcon = Icons.warning;
        break;
      case 'offline':
        statusColor = AppTheme.errorLight;
        statusIcon = Icons.circle;
        break;
      default:
        statusColor = AppTheme.textDisabledLight;
        statusIcon = Icons.circle;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          statusIcon,
          color: statusColor,
          size: 12,
        ),
        SizedBox(width: 1.w),
        Text(
          status,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryIndicator() {
    final batteryLevel = device["batteryLevel"] as int;
    Color batteryColor;

    if (batteryLevel > 50) {
      batteryColor = AppTheme.successColor;
    } else if (batteryLevel > 20) {
      batteryColor = AppTheme.warningColor;
    } else {
      batteryColor = AppTheme.errorLight;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'battery_std',
          color: batteryColor,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          '${batteryLevel}%',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: batteryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(BuildContext context,
      {required bool isLeftSwipe}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeftSwipe
            ? AppTheme.errorLight
            : AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeftSwipe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: isLeftSwipe ? 'delete' : 'more_horiz',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                isLeftSwipe ? 'Remove' : 'Actions',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildActionTile(
              context,
              icon: 'lock',
              title: 'Lock Device',
              subtitle: 'Lock the device remotely',
              onTap: () {
                Navigator.pop(context);
                onSwipeAction('lock');
              },
            ),
            _buildActionTile(
              context,
              icon: 'message',
              title: 'Send Message',
              subtitle: 'Send a message to the device',
              onTap: () {
                Navigator.pop(context);
                onSwipeAction('message');
              },
            ),
            _buildActionTile(
              context,
              icon: 'location_on',
              title: 'Locate Device',
              subtitle: 'Find the device location',
              onTap: () {
                Navigator.pop(context);
                onSwipeAction('locate');
              },
            ),
            _buildActionTile(
              context,
              icon: 'restart_alt',
              title: 'Restart Device',
              subtitle: 'Restart the device remotely',
              onTap: () {
                Navigator.pop(context);
                onSwipeAction('restart');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

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
}
