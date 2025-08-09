import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DevicePreviewWidget extends StatefulWidget {
  final String deviceName;
  final String connectionStatus;
  final DateTime lastUpdate;

  const DevicePreviewWidget({
    Key? key,
    required this.deviceName,
    required this.connectionStatus,
    required this.lastUpdate,
  }) : super(key: key);

  @override
  State<DevicePreviewWidget> createState() => _DevicePreviewWidgetState();
}

class _DevicePreviewWidgetState extends State<DevicePreviewWidget> {
  String _screenshotUrl =
      "https://images.pexels.com/photos/267350/pexels-photo-267350.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _startScreenshotRefresh();
  }

  void _startScreenshotRefresh() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _refreshScreenshot();
        _startScreenshotRefresh();
      }
    });
  }

  void _refreshScreenshot() {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate screenshot refresh with different images
    final screenshots = [
      "https://images.pexels.com/photos/267350/pexels-photo-267350.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pixabay.com/photo/2016/11/29/06/15/mobile-phone-1867510_1280.jpg",
      "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    ];

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _screenshotUrl =
              screenshots[DateTime.now().millisecond % screenshots.length];
          _isRefreshing = false;
        });
      }
    });
  }

  Color _getConnectionStatusColor() {
    switch (widget.connectionStatus.toLowerCase()) {
      case 'connected':
        return AppTheme.successColor;
      case 'connecting':
        return AppTheme.warningColor;
      case 'disconnected':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatLastUpdate() {
    final now = DateTime.now();
    final difference = now.difference(widget.lastUpdate);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with device info
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.deviceName,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color:
                            _getConnectionStatusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getConnectionStatusColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            widget.connectionStatus,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getConnectionStatusColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Last update: ${_formatLastUpdate()}",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Device screenshot preview
          Container(
            width: double.infinity,
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: _screenshotUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Refresh indicator overlay
                if (_isRefreshing)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Refreshing...",
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Manual refresh button
                Positioned(
                  top: 2.h,
                  right: 3.w,
                  child: GestureDetector(
                    onTap: _isRefreshing ? null : _refreshScreenshot,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: 'refresh',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
