import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PolicyCardWidget extends StatelessWidget {
  final Map<String, dynamic> policy;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDeploy;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const PolicyCardWidget({
    Key? key,
    required this.policy,
    this.onEdit,
    this.onDuplicate,
    this.onDeploy,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status =
        (policy["status"] as String? ?? "inactive").toLowerCase();
    final Color statusColor = _getStatusColor(status);
    final int deviceCount = policy["appliedDevices"] as int? ?? 0;
    final bool isActive = status == "active";

    return Dismissible(
      key: Key(policy["id"].toString()),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.successColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Edit',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.errorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              policy["name"] as String? ?? "Unnamed Policy",
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              policy["description"] as String? ??
                                  "No description available",
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textMediumEmphasisLight,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              status.toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'devices',
                              color: AppTheme.textMediumEmphasisLight,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '$deviceCount devices',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textMediumEmphasisLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildActionButton(
                            icon: 'content_copy',
                            onTap: onDuplicate,
                            tooltip: 'Duplicate',
                          ),
                          SizedBox(width: 2.w),
                          _buildActionButton(
                            icon: isActive ? 'pause' : 'play_arrow',
                            onTap: onDeploy,
                            tooltip: isActive ? 'Pause' : 'Deploy',
                            isPrimary: !isActive,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (policy["lastModified"] != null) ...[
                    SizedBox(height: 1.h),
                    Text(
                      'Modified: ${_formatDate(policy["lastModified"])}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textDisabledLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback? onTap,
    required String tooltip,
    bool isPrimary = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppTheme.primaryLight.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPrimary
                  ? AppTheme.primaryLight.withValues(alpha: 0.3)
                  : AppTheme.outlineLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isPrimary
                ? AppTheme.primaryLight
                : AppTheme.textMediumEmphasisLight,
            size: 16,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.successColor;
      case 'inactive':
        return AppTheme.textMediumEmphasisLight;
      case 'pending':
        return AppTheme.warningColor;
      case 'error':
        return AppTheme.errorLight;
      default:
        return AppTheme.textMediumEmphasisLight;
    }
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.month}/${date.day}/${date.year}';
    } else if (date is String) {
      try {
        final parsedDate = DateTime.parse(date);
        return '${parsedDate.month}/${parsedDate.day}/${parsedDate.year}';
      } catch (e) {
        return date;
      }
    }
    return 'Unknown';
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Delete Policy',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                'Are you sure you want to delete "${policy["name"]}"? This action cannot be undone.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onDelete?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorLight,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Delete',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
