import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrimaryControlsWidget extends StatefulWidget {
  final Function(String) onCommandExecuted;

  const PrimaryControlsWidget({
    Key? key,
    required this.onCommandExecuted,
  }) : super(key: key);

  @override
  State<PrimaryControlsWidget> createState() => _PrimaryControlsWidgetState();
}

class _PrimaryControlsWidgetState extends State<PrimaryControlsWidget> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLocked = false;
  String _selectedTemplate = '';
  final int _maxMessageLength = 200;

  final List<Map<String, String>> _messageTemplates = [
    {
      'title': 'Class Starting',
      'message':
          'Class is starting in 5 minutes. Please prepare your materials and focus on the lesson.'
    },
    {
      'title': 'Break Time',
      'message':
          'Break time! You have 15 minutes to relax. Please return to your device when break ends.'
    },
    {
      'title': 'Emergency',
      'message':
          'Emergency situation. Please follow your teacher\'s instructions immediately.'
    },
    {
      'title': 'Study Time',
      'message':
          'Study time has begun. Please focus on your assignments and avoid distractions.'
    },
    {
      'title': 'Exam Mode',
      'message':
          'Exam mode is now active. Only exam-related applications are available.'
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Send Message to Device',
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
                    // Template selection
                    Text(
                      'Quick Templates:',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _messageTemplates.map((template) {
                        final isSelected =
                            _selectedTemplate == template['title'];
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _selectedTemplate =
                                  isSelected ? '' : template['title']!;
                              _messageController.text =
                                  isSelected ? '' : template['message']!;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : AppTheme.lightTheme.colorScheme
                                      .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              template['title']!,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 2.h),

                    // Custom message input
                    Text(
                      'Custom Message:',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      maxLength: _maxMessageLength,
                      decoration: InputDecoration(
                        hintText: 'Enter your custom message...',
                        counterText:
                            '${_messageController.text.length}/$_maxMessageLength',
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value !=
                              _messageTemplates.firstWhere(
                                (template) =>
                                    template['title'] == _selectedTemplate,
                                orElse: () => {'message': ''},
                              )['message']) {
                            _selectedTemplate = '';
                          }
                        });
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Message preview
                    if (_messageController.text.isNotEmpty) ...[
                      Text(
                        'Preview:',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
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
                        child: Text(
                          _messageController.text,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _messageController.clear();
                    _selectedTemplate = '';
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _messageController.text.trim().isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          widget.onCommandExecuted(
                              'Send Message: ${_messageController.text}');
                          _messageController.clear();
                          _selectedTemplate = '';
                        },
                  child: Text('Send Message'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _takeScreenshot() {
    widget.onCommandExecuted('Take Screenshot');

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Screenshot captured and saved to gallery'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildControlButton({
    required String title,
    required String iconName,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    bool isDestructive = false,
  }) {
    return Expanded(
      child: Container(
        height: 12.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isDestructive
                    ? AppTheme.errorLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface),
            foregroundColor: textColor ??
                (isDestructive
                    ? AppTheme.errorLight
                    : AppTheme.lightTheme.colorScheme.onSurface),
            elevation: 2,
            shadowColor: AppTheme.shadowLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDestructive
                    ? AppTheme.errorLight.withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 2.h),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: textColor ??
                    (isDestructive
                        ? AppTheme.errorLight
                        : AppTheme.lightTheme.colorScheme.primary),
                size: 28,
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor ??
                      (isDestructive
                          ? AppTheme.errorLight
                          : AppTheme.lightTheme.colorScheme.onSurface),
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
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Primary Controls',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // First row of controls
          Row(
            children: [
              _buildControlButton(
                title: _isLocked ? 'Unlock Screen' : 'Lock Screen',
                iconName: _isLocked ? 'lock_open' : 'lock',
                onPressed: () {
                  setState(() {
                    _isLocked = !_isLocked;
                  });
                  widget.onCommandExecuted(
                      _isLocked ? 'Lock Screen' : 'Unlock Screen');
                },
              ),
              _buildControlButton(
                title: 'Send Message',
                iconName: 'message',
                onPressed: _showMessageDialog,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Second row of controls
          Row(
            children: [
              _buildControlButton(
                title: 'Take Screenshot',
                iconName: 'screenshot',
                onPressed: _takeScreenshot,
              ),
              _buildControlButton(
                title: 'Restart Device',
                iconName: 'restart_alt',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Restart Device'),
                        content: Text(
                            'Are you sure you want to restart this device? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              widget.onCommandExecuted('Restart Device');
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
                },
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
