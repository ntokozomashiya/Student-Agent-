import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertBannerWidget extends StatelessWidget {
  final String message;
  final String type;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  const AlertBannerWidget({
    super.key,
    required this.message,
    required this.type,
    this.onDismiss,
    this.onAction,
  });

  Color _getAlertColor() {
    switch (type.toLowerCase()) {
      case 'critical':
        return AppTheme.errorLight;
      case 'warning':
        return AppTheme.warningColor;
      case 'info':
        return AppTheme.primaryLight;
      default:
        return AppTheme.errorLight;
    }
  }

  String _getAlertIcon() {
    switch (type.toLowerCase()) {
      case 'critical':
        return 'error';
      case 'warning':
        return 'warning';
      case 'info':
        return 'info';
      default:
        return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertColor = _getAlertColor();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getAlertIcon(),
            color: alertColor,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textHighEmphasisLight,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onAction != null) ...[
            SizedBox(width: 2.w),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: alertColor,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
              child: Text(
                'View',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: alertColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (onDismiss != null) ...[
            SizedBox(width: 1.w),
            GestureDetector(
              onTap: onDismiss,
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textMediumEmphasisLight,
                size: 5.w,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
