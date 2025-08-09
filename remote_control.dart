import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_controls_widget.dart';
import './widgets/command_status_widget.dart';
import './widgets/device_preview_widget.dart';
import './widgets/emergency_controls_widget.dart';
import './widgets/primary_controls_widget.dart';

class RemoteControl extends StatefulWidget {
  const RemoteControl({Key? key}) : super(key: key);

  @override
  State<RemoteControl> createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControl> {
  final List<Map<String, dynamic>> _commandHistory = [];
  String _connectionLatency = "45ms";
  String _signalStrength = "Excellent";
  String _deviceName = "Student iPad - Room 204";
  String _connectionStatus = "Connected";
  DateTime _lastUpdate = DateTime.now().subtract(const Duration(minutes: 2));

  @override
  void initState() {
    super.initState();
    _initializeRemoteControl();
  }

  void _initializeRemoteControl() {
    // Initialize with some sample command history
    _commandHistory.addAll([
      {
        'command': 'Lock Screen',
        'status': 'executed',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      },
      {
        'command': 'Send Message: Class Starting',
        'status': 'executed',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 8)),
      },
      {
        'command': 'Take Screenshot',
        'status': 'executed',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 12)),
      },
      {
        'command': 'Toggle WiFi: OFF',
        'status': 'failed',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      },
    ]);

    // Simulate periodic connection updates
    _startConnectionMonitoring();
  }

  void _startConnectionMonitoring() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          // Simulate varying connection quality
          final latencies = ["32ms", "45ms", "67ms", "89ms", "123ms"];
          final strengths = ["Excellent", "Good", "Fair", "Poor"];

          _connectionLatency =
              latencies[DateTime.now().millisecond % latencies.length];
          _signalStrength =
              strengths[DateTime.now().millisecond % strengths.length];
          _lastUpdate = DateTime.now();
        });
        _startConnectionMonitoring();
      }
    });
  }

  void _onCommandExecuted(String command) {
    setState(() {
      _commandHistory.insert(0, {
        'command': command,
        'status': 'queued',
        'timestamp': DateTime.now(),
      });
    });

    // Simulate command processing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _commandHistory[0]['status'] = 'sent';
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          // Simulate success/failure based on command type
          final isEmergencyCommand = command.contains('Emergency') ||
              command.contains('Factory Reset') ||
              command.contains('Lost Mode');

          _commandHistory[0]['status'] =
              isEmergencyCommand && DateTime.now().millisecond % 3 == 0
                  ? 'failed'
                  : 'executed';
          _commandHistory[0]['timestamp'] = DateTime.now();
        });
      }
    });
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  void _showDeviceInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Device Information',
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
                _buildInfoRow('Device Name', _deviceName),
                _buildInfoRow('Status', _connectionStatus),
                _buildInfoRow('Last Update', _formatLastUpdate()),
                _buildInfoRow('Latency', _connectionLatency),
                _buildInfoRow('Signal Strength', _signalStrength),
                _buildInfoRow('Device ID', 'iPad-204-001'),
                _buildInfoRow('OS Version', 'iPadOS 17.2'),
                _buildInfoRow('Battery', '87%'),
                _buildInfoRow('Storage', '45.2 GB / 64 GB'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdate() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdate);

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
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Remote Control',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: _navigateBack,
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showDeviceInfo,
            icon: CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  setState(() {
                    _lastUpdate = DateTime.now();
                  });
                  break;
                case 'settings':
                  // Navigate to settings
                  break;
                case 'help':
                  // Show help dialog
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Refresh Connection'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Help'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device preview section
              DevicePreviewWidget(
                deviceName: _deviceName,
                connectionStatus: _connectionStatus,
                lastUpdate: _lastUpdate,
              ),

              // Primary controls section
              PrimaryControlsWidget(
                onCommandExecuted: _onCommandExecuted,
              ),

              // Advanced controls section
              AdvancedControlsWidget(
                onCommandExecuted: _onCommandExecuted,
              ),

              // Command status section
              CommandStatusWidget(
                commandHistory: _commandHistory,
                connectionLatency: _connectionLatency,
                signalStrength: _signalStrength,
              ),

              // Emergency controls section
              EmergencyControlsWidget(
                onCommandExecuted: _onCommandExecuted,
              ),

              // Bottom spacing
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),

      // Quick action floating button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _onCommandExecuted('Quick Screenshot');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'Quick Shot',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
