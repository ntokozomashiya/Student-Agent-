import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onLockSelected;
  final VoidCallback onSendBroadcast;
  final VoidCallback onApplyPolicy;
  final VoidCallback onClearSelection;

  const BulkActionsWidget({
    Key? key,
    required this.selectedCount,
    required this.onLockSelected,
    required this.onSendBroadcast,
    required this.onApplyPolicy,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: selectedCount > 0 ? 16.h : 0,
      child: selectedCount > 0
          ? Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$selectedCount selected',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: onClearSelection,
                        child: Text(
                          'Clear',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: 'lock',
                          label: 'Lock',
                          onTap: onLockSelected,
                          color: AppTheme.warningColor,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildActionButton(
                          icon: 'campaign',
                          label: 'Broadcast',
                          onTap: onSendBroadcast,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildActionButton(
                          icon: 'policy',
                          label: 'Policy',
                          onTap: onApplyPolicy,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
