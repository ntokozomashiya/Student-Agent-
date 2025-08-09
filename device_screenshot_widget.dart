import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceScreenshotWidget extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  const DeviceScreenshotWidget({
    Key? key,
    required this.deviceData,
  }) : super(key: key);

  @override
  State<DeviceScreenshotWidget> createState() => _DeviceScreenshotWidgetState();
}

class _DeviceScreenshotWidgetState extends State<DeviceScreenshotWidget> {
  bool _isRefreshing = false;
  String? _screenshotUrl;

  @override
  void initState() {
    super.initState();
    _screenshotUrl = widget.deviceData['screenshotUrl'] as String?;
  }

  Future<void> _refreshScreenshot() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate screenshot refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _screenshotUrl =
          'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?fm=jpg&q=60&w=400&h=600';
    });
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Device Screenshot',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: _isRefreshing ? null : _refreshScreenshot,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isRefreshing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: _screenshotUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: _screenshotUrl!,
                      width: double.infinity,
                      height: 40.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'phone_android',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No screenshot available',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Tap refresh to capture',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
