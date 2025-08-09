import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedControlsWidget extends StatefulWidget {
  final Function(String) onCommandExecuted;

  const AdvancedControlsWidget({
    Key? key,
    required this.onCommandExecuted,
  }) : super(key: key);

  @override
  State<AdvancedControlsWidget> createState() => _AdvancedControlsWidgetState();
}

class _AdvancedControlsWidgetState extends State<AdvancedControlsWidget> {
  bool _isExpanded = false;
  bool _wifiEnabled = true;
  bool _mobileDataEnabled = true;
  double _volumeLevel = 0.7;
  String _selectedApp = '';

  final List<Map<String, dynamic>> _installedApps = [
    {
      'name': 'Chrome Browser',
      'package': 'com.android.chrome',
      'icon': 'web',
      'isRunning': true,
    },
    {
      'name': 'Calculator',
      'package': 'com.android.calculator2',
      'icon': 'calculate',
      'isRunning': false,
    },
    {
      'name': 'Camera',
      'package': 'com.android.camera2',
      'icon': 'camera_alt',
      'isRunning': false,
    },
    {
      'name': 'Gallery',
      'package': 'com.android.gallery3d',
      'icon': 'photo_library',
      'isRunning': false,
    },
    {
      'name': 'Settings',
      'package': 'com.android.settings',
      'icon': 'settings',
      'isRunning': false,
    },
    {
      'name': 'YouTube',
      'package': 'com.google.android.youtube',
      'icon': 'play_circle',
      'isRunning': true,
    },
    {
      'name': 'Maps',
      'package': 'com.google.android.apps.maps',
      'icon': 'map',
      'isRunning': false,
    },
    {
      'name': 'Gmail',
      'package': 'com.google.android.gm',
      'icon': 'email',
      'isRunning': false,
    },
  ];

  void _showAppLauncher() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Launch Application',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: 80.w,
            height: 50.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select an application to launch:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _installedApps.length,
                    itemBuilder: (context, index) {
                      final app = _installedApps[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          widget
                              .onCommandExecuted('Launch App: ${app['name']}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CustomIconWidget(
                                    iconName: app['icon'],
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 32,
                                  ),
                                  if (app['isRunning'])
                                    Positioned(
                                      top: -2,
                                      right: -2,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppTheme.successColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.surface,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                app['name'],
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showRunningApps() {
    final runningApps =
        _installedApps.where((app) => app['isRunning']).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Close Application',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a running application to close:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                if (runningApps.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'apps',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 32,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No running applications',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...runningApps.map((app) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: ListTile(
                        leading: CustomIconWidget(
                          iconName: app['icon'],
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        title: Text(
                          app['name'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Running',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successColor,
                          ),
                        ),
                        trailing: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.errorLight,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onCommandExecuted('Close App: ${app['name']}');
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleControl({
    required String title,
    required String iconName,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: value
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              widget.onCommandExecuted(
                  'Toggle $title: ${newValue ? 'ON' : 'OFF'}');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String iconName,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Expanded(
      child: Container(
        height: 10.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? AppTheme.lightTheme.colorScheme.surface,
            foregroundColor:
                textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
            elevation: 1,
            shadowColor: AppTheme.shadowLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 1.h),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: textColor ?? AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
        children: [
          // Header with expand/collapse button
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
                children: [
                  Expanded(
                    child: Text(
                      'Advanced Controls',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Network controls
                  Text(
                    'Network Controls',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildToggleControl(
                    title: 'Wi-Fi',
                    iconName: 'wifi',
                    value: _wifiEnabled,
                    onChanged: (value) {
                      setState(() {
                        _wifiEnabled = value;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildToggleControl(
                    title: 'Mobile Data',
                    iconName: 'signal_cellular_alt',
                    value: _mobileDataEnabled,
                    onChanged: (value) {
                      setState(() {
                        _mobileDataEnabled = value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // App controls
                  Text(
                    'Application Controls',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      _buildActionButton(
                        title: 'Launch App',
                        iconName: 'launch',
                        onPressed: _showAppLauncher,
                      ),
                      _buildActionButton(
                        title: 'Close App',
                        iconName: 'close',
                        onPressed: _showRunningApps,
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Volume control
                  Text(
                    'Volume Control',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: _volumeLevel == 0
                              ? 'volume_off'
                              : _volumeLevel < 0.5
                                  ? 'volume_down'
                                  : 'volume_up',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Slider(
                            value: _volumeLevel,
                            onChanged: (value) {
                              setState(() {
                                _volumeLevel = value;
                              });
                            },
                            onChangeEnd: (value) {
                              widget.onCommandExecuted(
                                  'Set Volume: ${(value * 100).round()}%');
                            },
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${(_volumeLevel * 100).round()}%',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
