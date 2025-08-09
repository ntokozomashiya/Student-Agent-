import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityLogWidget extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  const ActivityLogWidget({
    Key? key,
    required this.deviceData,
  }) : super(key: key);

  @override
  State<ActivityLogWidget> createState() => _ActivityLogWidgetState();
}

class _ActivityLogWidgetState extends State<ActivityLogWidget> {
  bool _isExpanded = false;
  List<Map<String, dynamic>> _activityLog = [];

  @override
  void initState() {
    super.initState();
    _loadActivityLog();
  }

  void _loadActivityLog() {
    _activityLog = [
      {
        "id": 1,
        "type": "app_blocked",
        "title": "App Blocked",
        "description": "WhatsApp was blocked due to policy violation",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
        "severity": "warning",
        "details":
            "Student attempted to access WhatsApp during study hours. App was automatically blocked according to time-based restrictions."
      },
      {
        "id": 2,
        "type": "location_update",
        "title": "Location Updated",
        "description": "Device location updated to New York Public Library",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
        "severity": "info",
        "details":
            "GPS coordinates: 40.7128, -74.0060. Device is within approved educational zone."
      },
      {
        "id": 3,
        "type": "policy_violation",
        "title": "Policy Violation",
        "description": "Attempted to access restricted website",
        "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
        "severity": "error",
        "details":
            "Student tried to access social media website during class time. Access was denied and incident logged."
      },
      {
        "id": 4,
        "type": "app_installed",
        "title": "App Installed",
        "description": "Google Classroom installed successfully",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "severity": "success",
        "details":
            "Educational app Google Classroom (v1.9.442.19.90) was installed remotely. Installation completed without errors."
      },
      {
        "id": 5,
        "type": "screen_locked",
        "title": "Screen Locked",
        "description": "Device screen locked remotely",
        "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
        "severity": "info",
        "details":
            "Screen locked by administrator during exam period. Lock message displayed to student."
      },
      {
        "id": 6,
        "type": "network_change",
        "title": "Network Changed",
        "description": "Connected to school Wi-Fi network",
        "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
        "severity": "info",
        "details":
            "Device connected to 'SchoolWiFi_5G' network. Network policies applied automatically."
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

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'error':
        return AppTheme.errorLight;
      case 'warning':
        return AppTheme.warningColor;
      case 'success':
        return AppTheme.successColor;
      case 'info':
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'error':
        return 'error';
      case 'warning':
        return 'warning';
      case 'success':
        return 'check_circle';
      case 'info':
      default:
        return 'info';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    children: [
                      Text(
                        'Activity Log',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_activityLog.length}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
            Container(
              constraints: BoxConstraints(maxHeight: 50.h),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(4.w),
                itemCount: _activityLog.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final activity = _activityLog[index];
                  return _buildActivityItem(activity);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final String severity = activity['severity'] as String;
    final Color severityColor = _getSeverityColor(severity);
    final String severityIcon = _getSeverityIcon(severity);

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(top: 1.h, bottom: 2.h),
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: severityColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: severityIcon,
          color: severityColor,
          size: 16,
        ),
      ),
      title: Text(
        activity['title'] as String,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5.h),
          Text(
            activity['description'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            _formatTimestamp(activity['timestamp'] as DateTime),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            activity['details'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
