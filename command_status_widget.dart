import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommandStatusWidget extends StatefulWidget {
  final List<Map<String, dynamic>> commandHistory;
  final String connectionLatency;
  final String signalStrength;

  const CommandStatusWidget({
    Key? key,
    required this.commandHistory,
    required this.connectionLatency,
    required this.signalStrength,
  }) : super(key: key);

  @override
  State<CommandStatusWidget> createState() => _CommandStatusWidgetState();
}

class _CommandStatusWidgetState extends State<CommandStatusWidget> {
  bool _isExpanded = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'executed':
        return AppTheme.successColor;
      case 'sent':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'queued':
        return AppTheme.warningColor;
      case 'failed':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'executed':
        return Icons.check_circle;
      case 'sent':
        return Icons.send;
      case 'queued':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getSignalStrengthIcon() {
    switch (widget.signalStrength.toLowerCase()) {
      case 'excellent':
        return 'signal_cellular_4_bar';
      case 'good':
        return 'signal_cellular_3_bar';
      case 'fair':
        return 'signal_cellular_2_bar';
      case 'poor':
        return 'signal_cellular_1_bar';
      default:
        return 'signal_cellular_0_bar';
    }
  }

  Color _getSignalStrengthColor() {
    switch (widget.signalStrength.toLowerCase()) {
      case 'excellent':
      case 'good':
        return AppTheme.successColor;
      case 'fair':
        return AppTheme.warningColor;
      case 'poor':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  void _retryCommand(Map<String, dynamic> command) {
    // Simulate retry logic
    setState(() {
      command['status'] = 'queued';
      command['timestamp'] = DateTime.now();
    });

    // Simulate command execution after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          command['status'] = 'executed';
          command['timestamp'] = DateTime.now();
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Retrying command: ${command['command']}'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
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
          // Connection status header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Connection indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Connected',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 3.w),

                // Latency
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'speed',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.connectionLatency,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 3.w),

                // Signal strength
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getSignalStrengthIcon(),
                      color: _getSignalStrengthColor(),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.signalStrength,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getSignalStrengthColor(),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Expand/collapse button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Command history (expandable)
          if (_isExpanded) ...[
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Command History',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.commandHistory.length} commands',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  if (widget.commandHistory.isEmpty)
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
                            iconName: 'history',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'No commands executed yet',
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
                    ...widget.commandHistory.take(5).map((command) {
                      final status = command['status'] as String;
                      final statusColor = _getStatusColor(status);
                      final canRetry = status.toLowerCase() == 'failed';

                      return Container(
                        margin: EdgeInsets.only(bottom: 1.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                _getStatusIcon(status),
                                color: statusColor,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    command['command'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Row(
                                    children: [
                                      Text(
                                        status.toUpperCase(),
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        '•',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        _formatTimestamp(
                                            command['timestamp'] as DateTime),
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (canRetry) ...[
                              SizedBox(width: 2.w),
                              GestureDetector(
                                onTap: () => _retryCommand(command),
                                child: Container(
                                  padding: EdgeInsets.all(1.5.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'refresh',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  if (widget.commandHistory.length > 5) ...[
                    SizedBox(height: 1.h),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Show full command history
                        },
                        child: Text(
                          'View all ${widget.commandHistory.length} commands',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
