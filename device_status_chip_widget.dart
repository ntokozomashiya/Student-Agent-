import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DeviceStatusChipWidget extends StatelessWidget {
  final String status;
  final int count;
  final bool isSelected;
  final VoidCallback? onTap;

  const DeviceStatusChipWidget({
    super.key,
    required this.status,
    required this.count,
    this.isSelected = false,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.successColor;
      case 'offline':
        return AppTheme.textMediumEmphasisLight;
      case 'restricted':
        return AppTheme.warningColor;
      case 'emergency':
        return AppTheme.errorLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? statusColor.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? statusColor : AppTheme.outlineLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color:
                    isSelected ? statusColor : AppTheme.textHighEmphasisLight,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              status,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color:
                    isSelected ? statusColor : AppTheme.textMediumEmphasisLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
