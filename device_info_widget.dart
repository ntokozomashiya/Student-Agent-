import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceInfoWidget extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  const DeviceInfoWidget({
    Key? key,
    required this.deviceData,
  }) : super(key: key);

  @override
  State<DeviceInfoWidget> createState() => _DeviceInfoWidgetState();
}

class _DeviceInfoWidgetState extends State<DeviceInfoWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String osVersion =
        widget.deviceData['osVersion'] as String? ?? 'Unknown';
    final String storage = widget.deviceData['storage'] as String? ?? 'Unknown';
    final String network = widget.deviceData['network'] as String? ?? 'Unknown';
    final String serialNumber =
        widget.deviceData['serialNumber'] as String? ?? 'Unknown';
    final String lastSeen =
        widget.deviceData['lastSeen'] as String? ?? 'Unknown';
    final String ipAddress =
        widget.deviceData['ipAddress'] as String? ?? 'Unknown';

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
                    'Device Information',
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
                  _buildInfoRow('OS Version', osVersion, 'phone_android'),
                  SizedBox(height: 2.h),
                  _buildInfoRow('Storage', storage, 'storage'),
                  SizedBox(height: 2.h),
                  _buildInfoRow('Network', network, 'network_wifi'),
                  SizedBox(height: 2.h),
                  _buildInfoRow('Serial Number', serialNumber, 'tag'),
                  SizedBox(height: 2.h),
                  _buildInfoRow('IP Address', ipAddress, 'router'),
                  SizedBox(height: 2.h),
                  _buildInfoRow('Last Seen', lastSeen, 'schedule'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
