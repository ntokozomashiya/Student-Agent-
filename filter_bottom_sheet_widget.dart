import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late String selectedFilter;

  final List<Map<String, dynamic>> filterOptions = [
    {
      "id": "All",
      "title": "All Devices",
      "subtitle": "Show all devices",
      "icon": "devices",
    },
    {
      "id": "Online",
      "title": "Online",
      "subtitle": "Currently connected devices",
      "icon": "wifi",
    },
    {
      "id": "Offline",
      "title": "Offline",
      "subtitle": "Disconnected devices",
      "icon": "wifi_off",
    },
    {
      "id": "Tablet",
      "title": "Tablets",
      "subtitle": "Tablet devices only",
      "icon": "tablet",
    },
    {
      "id": "Phone",
      "title": "Phones",
      "subtitle": "Phone devices only",
      "icon": "smartphone",
    },
    {
      "id": "Managed",
      "title": "Managed",
      "subtitle": "Devices with active policies",
      "icon": "admin_panel_settings",
    },
    {
      "id": "Unmanaged",
      "title": "Unmanaged",
      "subtitle": "Devices without policies",
      "icon": "no_accounts",
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.currentFilter;
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
                      'Filter Devices',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = 'All';
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
              itemCount: filterOptions.length,
              itemBuilder: (context, index) {
                final option = filterOptions[index];
                final isSelected = selectedFilter == option["id"];

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
                        selectedFilter = option["id"] as String;
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
                      widget.onFilterChanged(selectedFilter);
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filter'),
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
