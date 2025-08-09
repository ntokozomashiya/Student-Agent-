import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> deviceData;

  const DeviceHeaderWidget({
    Key? key,
    required this.deviceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String deviceName = deviceData['name'] as String? ?? 'Unknown Device';
    final String deviceModel =
        deviceData['model'] as String? ?? 'Unknown Model';
    final String status = deviceData['status'] as String? ?? 'offline';
    final int batteryLevel = deviceData['batteryLevel'] as int? ?? 0;
    final bool isOnline = status.toLowerCase() == 'online';

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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deviceName,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      deviceModel,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isOnline
                      ? AppTheme.successColor.withValues(alpha: 0.1)
                      : AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppTheme.successColor
                            : AppTheme.errorLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      status.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isOnline
                            ? AppTheme.successColor
                            : AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'battery_std',
                color: batteryLevel > 20
                    ? AppTheme.successColor
                    : AppTheme.warningColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                '$batteryLevel%',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: isOnline ? 'wifi' : 'wifi_off',
                color: isOnline ? AppTheme.successColor : AppTheme.errorLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                isOnline ? 'Connected' : 'Disconnected',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
