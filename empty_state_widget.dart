import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type;
  final VoidCallback? onAddDevice;

  const EmptyStateWidget({
    Key? key,
    required this.type,
    this.onAddDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getEmptyStateIcon(),
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.6),
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _getEmptyStateTitle(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _getEmptyStateSubtitle(),
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (type == 'no_devices' && onAddDevice != null) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: onAddDevice,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text('Add Device'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                ),
              ),
            ],
            if (type == 'search_results') ...[
              SizedBox(height: 4.h),
              OutlinedButton.icon(
                onPressed: () {
                  // Clear search functionality would be handled by parent
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEmptyStateIcon() {
    switch (type) {
      case 'no_devices':
        return 'devices';
      case 'search_results':
        return 'search_off';
      case 'filter_results':
        return 'filter_list_off';
      case 'offline':
        return 'wifi_off';
      default:
        return 'devices';
    }
  }

  String _getEmptyStateTitle() {
    switch (type) {
      case 'no_devices':
        return 'No Devices Found';
      case 'search_results':
        return 'No Search Results';
      case 'filter_results':
        return 'No Matching Devices';
      case 'offline':
        return 'You\'re Offline';
      default:
        return 'No Devices';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (type) {
      case 'no_devices':
        return 'Start by adding devices to your Student Agent management system. Devices will appear here once registered.';
      case 'search_results':
        return 'We couldn\'t find any devices matching your search. Try different keywords or check your spelling.';
      case 'filter_results':
        return 'No devices match your current filter criteria. Try adjusting your filters or clearing them.';
      case 'offline':
        return 'Please check your internet connection. Cached device data may be shown when available.';
      default:
        return 'No devices available at the moment.';
    }
  }
}
