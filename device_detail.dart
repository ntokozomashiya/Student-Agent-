import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_log_widget.dart';
import './widgets/device_header_widget.dart';
import './widgets/device_info_widget.dart';
import './widgets/device_screenshot_widget.dart';
import './widgets/emergency_controls_widget.dart';
import './widgets/installed_apps_widget.dart';
import './widgets/location_history_widget.dart';
import './widgets/quick_actions_widget.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({Key? key}) : super(key: key);

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  late Map<String, dynamic> _deviceData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceData();
  }

  Future<void> _loadDeviceData() async {
    // Simulate loading device data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _deviceData = {
        "id": "device_001",
        "name": "Student iPad - Sarah Johnson",
        "model": "iPad Air (5th generation)",
        "status": "online",
        "batteryLevel": 78,
        "isLocked": false,
        "osVersion": "iOS 17.1.2",
        "storage": "64GB (42GB used)",
        "network": "SchoolWiFi_5G",
        "serialNumber": "DMQK2LL/A",
        "lastSeen": "2 minutes ago",
        "ipAddress": "192.168.1.145",
        "screenshotUrl":
            "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?fm=jpg&q=60&w=400&h=600",
        "currentApp": "Safari",
        "networkActivity": "2.3 MB/s",
        "policyViolations": 0,
        "enrollmentDate": "2024-01-15",
        "lastPolicyUpdate": "2024-08-01"
      };
      _isLoading = false;
    });
  }

  void _handleLockToggle() {
    setState(() {
      _deviceData['isLocked'] = !(_deviceData['isLocked'] as bool);
    });

    final String action =
        _deviceData['isLocked'] as bool ? 'locked' : 'unlocked';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device has been $action successfully'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSendMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController messageController = TextEditingController();

        return AlertDialog(
          title: Text(
            'Send Message to Device',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter a message to display on the student\'s device:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message sent to device successfully'),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _handleLocate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location request sent to device'),
        backgroundColor: AppTheme.accentColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRestart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Restart Device',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.warningColor,
            ),
          ),
          content: Text(
            'Are you sure you want to restart this device? The student will lose any unsaved work.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Restart command sent to device'),
                    backgroundColor: AppTheme.warningColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningColor,
              ),
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _handleScreenshot() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Screenshot captured successfully'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleEmergencyUnlock() {
    setState(() {
      _deviceData['isLocked'] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emergency unlock completed - All restrictions bypassed'),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleFactoryReset() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Factory reset initiated - Device will restart shortly'),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRemoveDevice() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device removed from management system'),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Device Details',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadDeviceData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to remote control
              Navigator.pushNamed(context, '/remote-control');
            },
            icon: CustomIconWidget(
              iconName: 'settings_remote',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading device information...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    // Device Header
                    DeviceHeaderWidget(deviceData: _deviceData),
                    SizedBox(height: 3.h),

                    // Device Screenshot
                    DeviceScreenshotWidget(deviceData: _deviceData),
                    SizedBox(height: 3.h),

                    // Quick Actions
                    QuickActionsWidget(
                      deviceData: _deviceData,
                      onLockToggle: _handleLockToggle,
                      onSendMessage: _handleSendMessage,
                      onLocate: _handleLocate,
                      onRestart: _handleRestart,
                      onScreenshot: _handleScreenshot,
                    ),
                    SizedBox(height: 3.h),

                    // Device Information
                    DeviceInfoWidget(deviceData: _deviceData),
                    SizedBox(height: 3.h),

                    // Installed Apps
                    InstalledAppsWidget(deviceData: _deviceData),
                    SizedBox(height: 3.h),

                    // Location History
                    LocationHistoryWidget(deviceData: _deviceData),
                    SizedBox(height: 3.h),

                    // Activity Log
                    ActivityLogWidget(deviceData: _deviceData),
                    SizedBox(height: 3.h),

                    // Emergency Controls
                    EmergencyControlsWidget(
                      deviceData: _deviceData,
                      onEmergencyUnlock: _handleEmergencyUnlock,
                      onFactoryReset: _handleFactoryReset,
                      onRemoveDevice: _handleRemoveDevice,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
    );
  }
}
