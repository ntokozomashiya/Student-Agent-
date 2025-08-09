import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final String currentFilter;
  final String currentSort;

  const SearchFilterBarWidget({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.onSortTap,
    required this.currentFilter,
    required this.currentSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search devices, students...',
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.textMediumEmphasisLight,
                          size: 20,
                        ),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                onSearchChanged('');
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme.textMediumEmphasisLight,
                                size: 20,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              _buildActionButton(
                icon: 'filter_list',
                onTap: onFilterTap,
                hasIndicator: currentFilter != 'All',
              ),
              SizedBox(width: 2.w),
              _buildActionButton(
                icon: 'sort',
                onTap: onSortTap,
                hasIndicator: currentSort != 'Name',
              ),
            ],
          ),
          if (currentFilter != 'All' || currentSort != 'Name')
            Container(
              margin: EdgeInsets.only(top: 2.h),
              child: Row(
                children: [
                  if (currentFilter != 'All')
                    _buildFilterChip(
                      label: 'Filter: $currentFilter',
                      onRemove: () => onFilterTap(),
                    ),
                  if (currentFilter != 'All' && currentSort != 'Name')
                    SizedBox(width: 2.w),
                  if (currentSort != 'Name')
                    _buildFilterChip(
                      label: 'Sort: $currentSort',
                      onRemove: () => onSortTap(),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onTap,
    bool hasIndicator = false,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        if (hasIndicator)
          Positioned(
            top: 1.w,
            right: 1.w,
            child: Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onRemove,
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
