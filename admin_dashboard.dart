import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/alert_banner_widget.dart';
import './widgets/device_status_chip_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/scheduled_task_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedStatusIndex = 0;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _alerts = [];

  // Mock data for dashboard metrics
  final Map<String, dynamic> dashboardMetrics = {
    "totalDevices": 1247,
    "onlineDevices": 1089,
    "policyViolations": 23,
    "recentActivities": 156,
    "institutionName": "Lincoln High School",
    "pendingAlerts": 5,
  };

  // Mock data for device status breakdown
  final List<Map<String, dynamic>> deviceStatusData = [
    {"status": "Active", "count": 1089},
    {"status": "Offline", "count": 158},
    {"status": "Restricted", "count": 23},
    {"status": "Emergency", "count": 2},
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "deviceName": "iPad-Student-A127",
      "action": "Screen locked due to inappropriate content access",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "priority": "high",
    },
    {
      "id": 2,
      "deviceName": "Tablet-Room-B204",
      "action": "Policy violation: Unauthorized app installation attempt",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 12)),
      "priority": "high",
    },
    {
      "id": 3,
      "deviceName": "Phone-Teacher-C301",
      "action": "Emergency unlock requested and approved",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 18)),
      "priority": "medium",
    },
    {
      "id": 4,
      "deviceName": "iPad-Student-D089",
      "action": "Automatic app update completed successfully",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      "priority": "low",
    },
    {
      "id": 5,
      "deviceName": "Tablet-Library-E156",
      "action": "Wi-Fi connectivity restored after maintenance",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "priority": "low",
    },
  ];

  // Mock data for scheduled tasks
  final List<Map<String, dynamic>> scheduledTasks = [
    {
      "id": 1,
      "title": "System Maintenance",
      "description": "Weekly device health check and optimization",
      "type": "maintenance",
      "status": "pending",
      "scheduledTime": DateTime.now().add(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "title": "Policy Update Deployment",
      "description": "New content filtering rules for Grade 9-12",
      "type": "policy",
      "status": "running",
      "scheduledTime": DateTime.now().add(const Duration(minutes: 30)),
    },
    {
      "id": 3,
      "title": "Backup Operation",
      "description": "Daily backup of device configurations and logs",
      "type": "backup",
      "status": "completed",
      "scheduledTime": DateTime.now().subtract(const Duration(hours: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeCriticalAlerts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeCriticalAlerts() {
    // Add critical alerts based on mock data
    if (dashboardMetrics["policyViolations"] > 20) {
      _alerts.add({
        "message":
            "High number of policy violations detected. Immediate review recommended.",
        "type": "critical",
      });
    }

    final emergencyDevices = deviceStatusData.firstWhere(
      (status) => status["status"] == "Emergency",
      orElse: () => {"count": 0},
    )["count"] as int;

    if (emergencyDevices > 0) {
      _alerts.add({
        "message":
            "$emergencyDevices devices in emergency mode require immediate attention.",
        "type": "critical",
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'lock_all':
        _showActionDialog('Lock All Devices',
            'Are you sure you want to lock all active devices?');
        break;
      case 'send_message':
        _showMessageDialog();
        break;
      case 'emergency_unlock':
        _showActionDialog(
            'Emergency Unlock', 'This will unlock all devices. Continue?');
        break;
    }
  }

  void _showActionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle action execution
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title executed successfully')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showMessageDialog() {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Message to All Devices'),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Enter your message...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Message sent to all devices')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _handleActivityTap(Map<String, dynamic> activity) {
    Navigator.pushNamed(context, '/device-detail');
  }

  void _handleActivityLongPress(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.primaryLight,
                  size: 6.w,
                ),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _handleActivityTap(activity);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'settings_remote',
                  color: AppTheme.primaryLight,
                  size: 6.w,
                ),
                title: const Text('Remote Control'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/remote-control');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'policy',
                  color: AppTheme.primaryLight,
                  size: 6.w,
                ),
                title: const Text('Manage Policies'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/policy-management');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _dismissAlert(int index) {
    setState(() {
      _alerts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          dashboardMetrics["institutionName"] as String,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Handle notifications
                },
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),
              if (dashboardMetrics["pendingAlerts"] > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 5.w,
                      minHeight: 5.w,
                    ),
                    child: Text(
                      dashboardMetrics["pendingAlerts"].toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Devices'),
            Tab(text: 'Policies'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPlaceholderTab('Devices'),
          _buildPlaceholderTab('Policies'),
          _buildPlaceholderTab('Reports'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleQuickAction('send_message'),
        backgroundColor: AppTheme.accentColor,
        child: CustomIconWidget(
          iconName: 'message',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Critical Alerts
              if (_alerts.isNotEmpty) ...[
                ...List.generate(_alerts.length, (index) {
                  final alert = _alerts[index];
                  return AlertBannerWidget(
                    message: alert["message"] as String,
                    type: alert["type"] as String,
                    onDismiss: () => _dismissAlert(index),
                    onAction: () {
                      // Handle alert action
                    },
                  );
                }),
              ],

              SizedBox(height: 2.h),

              // Key Metrics Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricCardWidget(
                          title: 'Total Devices',
                          value: dashboardMetrics["totalDevices"].toString(),
                          subtitle: 'Registered in system',
                          onTap: () =>
                              Navigator.pushNamed(context, '/device-list'),
                        ),
                        MetricCardWidget(
                          title: 'Online Now',
                          value: dashboardMetrics["onlineDevices"].toString(),
                          subtitle:
                              '${((dashboardMetrics["onlineDevices"] / dashboardMetrics["totalDevices"]) * 100).toInt()}% connected',
                          backgroundColor:
                              AppTheme.successColor.withValues(alpha: 0.1),
                          textColor: AppTheme.successColor,
                          onTap: () =>
                              Navigator.pushNamed(context, '/device-list'),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricCardWidget(
                          title: 'Violations',
                          value:
                              dashboardMetrics["policyViolations"].toString(),
                          subtitle: 'Require attention',
                          backgroundColor:
                              AppTheme.warningColor.withValues(alpha: 0.1),
                          textColor: AppTheme.warningColor,
                          onTap: () => Navigator.pushNamed(
                              context, '/policy-management'),
                        ),
                        MetricCardWidget(
                          title: 'Activities',
                          value:
                              dashboardMetrics["recentActivities"].toString(),
                          subtitle: 'Last 24 hours',
                          onTap: () {
                            // Show activities detail
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Device Status Breakdown
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Device Status',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 12.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: deviceStatusData.length,
                        itemBuilder: (context, index) {
                          final statusData = deviceStatusData[index];
                          return DeviceStatusChipWidget(
                            status: statusData["status"] as String,
                            count: statusData["count"] as int,
                            isSelected: _selectedStatusIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedStatusIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Quick Actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        QuickActionButtonWidget(
                          title: 'Lock All',
                          iconName: 'lock',
                          backgroundColor: AppTheme.warningColor,
                          onPressed: () => _handleQuickAction('lock_all'),
                        ),
                        SizedBox(width: 3.w),
                        QuickActionButtonWidget(
                          title: 'Send Message',
                          iconName: 'message',
                          onPressed: () => _handleQuickAction('send_message'),
                        ),
                        SizedBox(width: 3.w),
                        QuickActionButtonWidget(
                          title: 'Emergency Unlock',
                          iconName: 'lock_open',
                          backgroundColor: AppTheme.errorLight,
                          onPressed: () =>
                              _handleQuickAction('emergency_unlock'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Recent Activities
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Activities',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Show all activities
                          },
                          child: Text(
                            'View All',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.primaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    ...List.generate(
                      recentActivities.take(5).length,
                      (index) {
                        final activity = recentActivities[index];
                        return ActivityItemWidget(
                          activity: activity,
                          onTap: () => _handleActivityTap(activity),
                          onLongPress: () => _handleActivityLongPress(activity),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Scheduled Tasks
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scheduled Tasks',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ...List.generate(
                      scheduledTasks.length,
                      (index) {
                        final task = scheduledTasks[index];
                        return ScheduledTaskWidget(
                          task: task,
                          onTap: () {
                            // Handle task tap
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h), // Bottom padding for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.textMediumEmphasisLight,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            '$tabName Coming Soon',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This section is under development',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }
}
