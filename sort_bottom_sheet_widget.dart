import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatefulWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortBottomSheetWidget({
    Key? key,
    required this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  State<SortBottomSheetWidget> createState() => _SortBottomSheetWidgetState();
}

class _SortBottomSheetWidgetState extends State<SortBottomSheetWidget> {
  late String selectedSort;

  final List<Map<String, dynamic>> sortOptions = [
    {
      "id": "Name",
      "title": "Device Name",
      "subtitle": "Sort alphabetically by device name",
      "icon": "sort_by_alpha",
    },
    {
      "id": "Student",
      "title": "Student Name",
      "subtitle": "Sort alphabetically by student name",
      "icon": "person",
    },
    {
      "id": "LastSeen",
      "title": "Last Seen",
      "subtitle": "Sort by most recently active",
      "icon": "schedule",
    },
    {
      "id": "Battery",
      "title": "Battery Level",
      "subtitle": "Sort by battery percentage",
      "icon": "battery_std",
    },
    {
      "id": "Status",
      "title": "Status",
      "subtitle": "Sort by online/offline status",
      "icon": "signal_wifi_4_bar",
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedSort = widget.currentSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      'Sort Devices',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSort = 'Name';
                        });
                      },
                      child: Text(
                        'Reset',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final option = sortOptions[index];
                final isSelected = selectedSort == option["id"];

                return Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3))
                        : null,
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: option["icon"] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.textMediumEmphasisLight,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      option["title"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      option["subtitle"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.7)
                            : AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        selectedSort = option["id"] as String;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(6.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSortChanged(selectedSort);
                      Navigator.pop(context);
                    },
                    child: Text('Apply Sort'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
