import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InstalledAppsWidget extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  const InstalledAppsWidget({
    Key? key,
    required this.deviceData,
  }) : super(key: key);

  @override
  State<InstalledAppsWidget> createState() => _InstalledAppsWidgetState();
}

class _InstalledAppsWidgetState extends State<InstalledAppsWidget> {
  bool _isExpanded = false;
  List<Map<String, dynamic>> _installedApps = [];

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  void _loadInstalledApps() {
    _installedApps = [
      {
        "id": "com.google.chrome",
        "name": "Chrome",
        "icon":
            "https://images.pexels.com/photos/267350/pexels-photo-267350.jpeg?auto=compress&cs=tinysrgb&w=100",
        "isBlocked": false,
        "version": "118.0.5993.117",
        "size": "156 MB"
      },
      {
        "id": "com.whatsapp",
        "name": "WhatsApp",
        "icon":
            "https://images.pexels.com/photos/147413/twitter-facebook-together-exchange-of-information-147413.jpeg?auto=compress&cs=tinysrgb&w=100",
        "isBlocked": true,
        "version": "2.23.24.76",
        "size": "89 MB"
      },
      {
        "id": "com.google.android.youtube",
        "name": "YouTube",
        "icon":
            "https://images.pexels.com/photos/1591056/pexels-photo-1591056.jpeg?auto=compress&cs=tinysrgb&w=100",
        "isBlocked": false,
        "version": "18.45.43",
        "size": "134 MB"
      },
      {
        "id": "com.instagram.android",
        "name": "Instagram",
        "icon":
            "https://images.pexels.com/photos/1591061/pexels-photo-1591061.jpeg?auto=compress&cs=tinysrgb&w=100",
        "isBlocked": true,
        "version": "302.0.0.23.108",
        "size": "67 MB"
      },
      {
        "id": "com.google.android.apps.docs.editors.docs",
        "name": "Google Docs",
        "icon":
            "https://images.pexels.com/photos/1591062/pexels-photo-1591062.jpeg?auto=compress&cs=tinysrgb&w=100",
        "isBlocked": false,
        "version": "1.23.442.02.90",
        "size": "45 MB"
      }
    ];
  }

  void _toggleAppBlock(int index) {
    setState(() {
      _installedApps[index]['isBlocked'] =
          !(_installedApps[index]['isBlocked'] as bool);
    });
  }

  void _uninstallApp(int index) {
    setState(() {
      _installedApps.removeAt(index);
    });
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
                        'Installed Apps',
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
                          '${_installedApps.length}',
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
              constraints: BoxConstraints(maxHeight: 40.h),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(4.w),
                itemCount: _installedApps.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final app = _installedApps[index];
                  return Dismissible(
                    key: Key(app['id'] as String),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'delete',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    onDismissed: (direction) => _uninstallApp(index),
                    child: _buildAppItem(app, index),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppItem(Map<String, dynamic> app, int index) {
    final bool isBlocked = app['isBlocked'] as bool;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isBlocked
            ? AppTheme.errorLight.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBlocked
              ? AppTheme.errorLight.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: app['icon'] as String,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['name'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${app['version']} • ${app['size']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: !isBlocked,
            onChanged: (value) => _toggleAppBlock(index),
            activeColor: AppTheme.successColor,
            inactiveThumbColor: AppTheme.errorLight,
            inactiveTrackColor: AppTheme.errorLight.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
