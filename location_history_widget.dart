import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationHistoryWidget extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  const LocationHistoryWidget({
    Key? key,
    required this.deviceData,
  }) : super(key: key);

  @override
  State<LocationHistoryWidget> createState() => _LocationHistoryWidgetState();
}

class _LocationHistoryWidgetState extends State<LocationHistoryWidget> {
  bool _isExpanded = false;
  List<Map<String, dynamic>> _locationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadLocationHistory();
  }

  void _loadLocationHistory() {
    _locationHistory = [
      {
        "id": 1,
        "latitude": 40.7128,
        "longitude": -74.0060,
        "address": "New York Public Library, 5th Ave, New York, NY",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
        "accuracy": "5m",
        "isGeofenced": true
      },
      {
        "id": 2,
        "latitude": 40.7589,
        "longitude": -73.9851,
        "address": "Central Park, New York, NY",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "accuracy": "8m",
        "isGeofenced": false
      },
      {
        "id": 3,
        "latitude": 40.7505,
        "longitude": -73.9934,
        "address": "Times Square, New York, NY",
        "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
        "accuracy": "12m",
        "isGeofenced": false
      },
      {
        "id": 4,
        "latitude": 40.7614,
        "longitude": -73.9776,
        "address": "Lincoln Center, New York, NY",
        "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
        "accuracy": "6m",
        "isGeofenced": true
      }
    ];
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation =
        _locationHistory.isNotEmpty ? _locationHistory.first : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location History',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Map placeholder
                  Container(
                    width: double.infinity,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Map background
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl:
                                'https://images.unsplash.com/photo-1524661135-423995f22d0b?fm=jpg&q=60&w=800&h=400',
                            width: double.infinity,
                            height: 25.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Current location indicator
                        if (currentLocation != null)
                          Positioned(
                            top: 8.h,
                            left: 40.w,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.errorLight,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: CustomIconWidget(
                                iconName: 'my_location',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        // Map controls
                        Positioned(
                          top: 2.w,
                          right: 2.w,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'fullscreen',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Current location info
                  if (currentLocation != null) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.successColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.successColor,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Location',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  currentLocation['address'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  '${_formatTimestamp(currentLocation['timestamp'] as DateTime)} • Accuracy: ${currentLocation['accuracy']}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  // Location history list
                  Container(
                    constraints: BoxConstraints(maxHeight: 30.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _locationHistory.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final location = _locationHistory[index];
                        final bool isGeofenced =
                            location['isGeofenced'] as bool;

                        return Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: isGeofenced
                                      ? AppTheme.successColor
                                          .withValues(alpha: 0.1)
                                      : AppTheme.warningColor
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: isGeofenced
                                      ? 'gps_fixed'
                                      : 'gps_not_fixed',
                                  color: isGeofenced
                                      ? AppTheme.successColor
                                      : AppTheme.warningColor,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      location['address'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      '${_formatTimestamp(location['timestamp'] as DateTime)} • ${location['accuracy']}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
