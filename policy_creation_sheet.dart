import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PolicyCreationSheet extends StatefulWidget {
  final Map<String, dynamic>? existingPolicy;
  final Function(Map<String, dynamic>) onPolicyCreated;

  const PolicyCreationSheet({
    Key? key,
    this.existingPolicy,
    required this.onPolicyCreated,
  }) : super(key: key);

  @override
  State<PolicyCreationSheet> createState() => _PolicyCreationSheetState();
}

class _PolicyCreationSheetState extends State<PolicyCreationSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Policy settings
  bool _blockSocialMedia = false;
  bool _blockGames = false;
  bool _blockBrowser = false;
  bool _enableContentFilter = false;
  bool _enableTimeRestrictions = false;
  bool _enableLocationTracking = false;

  // Time restrictions
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  // Selected apps to block
  final List<String> _selectedApps = [];

  // Content filter categories
  final Map<String, bool> _contentCategories = {
    'Adult Content': true,
    'Violence': true,
    'Gambling': false,
    'Social Media': false,
    'Gaming': false,
    'Shopping': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadExistingPolicy();
  }

  void _loadExistingPolicy() {
    if (widget.existingPolicy != null) {
      final policy = widget.existingPolicy!;
      _nameController.text = policy["name"] as String? ?? "";
      _descriptionController.text = policy["description"] as String? ?? "";

      final settings = policy["settings"] as Map<String, dynamic>? ?? {};
      _blockSocialMedia = settings["blockSocialMedia"] as bool? ?? false;
      _blockGames = settings["blockGames"] as bool? ?? false;
      _blockBrowser = settings["blockBrowser"] as bool? ?? false;
      _enableContentFilter = settings["enableContentFilter"] as bool? ?? false;
      _enableTimeRestrictions =
          settings["enableTimeRestrictions"] as bool? ?? false;
      _enableLocationTracking =
          settings["enableLocationTracking"] as bool? ?? false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(),
                _buildAppRestrictionsTab(),
                _buildContentFilteringTab(),
                _buildAdvancedSettingsTab(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.outlineLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.existingPolicy != null
                  ? 'Edit Policy'
                  : 'Create New Policy',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textMediumEmphasisLight,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.outlineLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Basic Info'),
          Tab(text: 'App Restrictions'),
          Tab(text: 'Content Filter'),
          Tab(text: 'Advanced'),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Policy Information',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Policy Name',
                hintText: 'Enter policy name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a policy name';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter policy description',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Settings',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSwitchTile(
              'Enable Content Filtering',
              'Block inappropriate content automatically',
              _enableContentFilter,
              (value) => setState(() => _enableContentFilter = value),
            ),
            _buildSwitchTile(
              'Time Restrictions',
              'Limit device usage to specific hours',
              _enableTimeRestrictions,
              (value) => setState(() => _enableTimeRestrictions = value),
            ),
            _buildSwitchTile(
              'Location Tracking',
              'Track device location for safety',
              _enableLocationTracking,
              (value) => setState(() => _enableLocationTracking = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppRestrictionsTab() {
    final List<Map<String, dynamic>> availableApps = [
      {
        "name": "Instagram",
        "package": "com.instagram.android",
        "icon": "photo_camera"
      },
      {
        "name": "TikTok",
        "package": "com.zhiliaoapp.musically",
        "icon": "video_library"
      },
      {
        "name": "YouTube",
        "package": "com.google.android.youtube",
        "icon": "play_circle"
      },
      {
        "name": "Facebook",
        "package": "com.facebook.katana",
        "icon": "facebook"
      },
      {
        "name": "Snapchat",
        "package": "com.snapchat.android",
        "icon": "camera_alt"
      },
      {"name": "WhatsApp", "package": "com.whatsapp", "icon": "chat"},
      {"name": "Chrome", "package": "com.android.chrome", "icon": "web"},
      {"name": "Games", "package": "games.*", "icon": "sports_esports"},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Restrictions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select apps to block on managed devices',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSwitchTile(
            'Block Social Media Apps',
            'Automatically block popular social media applications',
            _blockSocialMedia,
            (value) => setState(() => _blockSocialMedia = value),
          ),
          _buildSwitchTile(
            'Block Gaming Apps',
            'Prevent access to games and entertainment apps',
            _blockGames,
            (value) => setState(() => _blockGames = value),
          ),
          _buildSwitchTile(
            'Block Web Browsers',
            'Restrict web browsing capabilities',
            _blockBrowser,
            (value) => setState(() => _blockBrowser = value),
          ),
          SizedBox(height: 2.h),
          Text(
            'Specific Apps',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableApps.length,
            itemBuilder: (context, index) {
              final app = availableApps[index];
              final isSelected = _selectedApps.contains(app["package"]);

              return CheckboxListTile(
                title: Text(
                  app["name"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  app["package"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
                secondary: CustomIconWidget(
                  iconName: app["icon"] as String,
                  color: AppTheme.textMediumEmphasisLight,
                  size: 24,
                ),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedApps.add(app["package"] as String);
                    } else {
                      _selectedApps.remove(app["package"]);
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentFilteringTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Filtering',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Configure what content should be blocked',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Content Categories',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ..._contentCategories.entries.map((entry) {
            return _buildSwitchTile(
              entry.key,
              'Block ${entry.key.toLowerCase()} content',
              entry.value,
              (value) => setState(() => _contentCategories[entry.key] = value),
            );
          }).toList(),
          SizedBox(height: 2.h),
          Text(
            'Custom URLs',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Blocked URLs',
              hintText: 'Enter URLs to block (one per line)',
            ),
            maxLines: 4,
          ),
          SizedBox(height: 2.h),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Allowed URLs',
              hintText: 'Enter URLs to always allow (one per line)',
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Settings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          if (_enableTimeRestrictions) ...[
            Text(
              'Time Restrictions',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, true),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.outlineLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Time',
                            style: AppTheme.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            _startTime.format(context),
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, false),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.outlineLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Time',
                            style: AppTheme.lightTheme.textTheme.labelMedium,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            _endTime.format(context),
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
          Text(
            'Device Targeting',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                  color: AppTheme.outlineLight.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply to Device Groups',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: [
                    _buildGroupChip('All Devices', true),
                    _buildGroupChip('Grade 9', false),
                    _buildGroupChip('Grade 10', false),
                    _buildGroupChip('Teachers', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: SwitchListTile(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildGroupChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Handle group selection
      },
      selectedColor: AppTheme.primaryLight.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryLight,
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.outlineLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _savePolicy,
              child: Text(widget.existingPolicy != null
                  ? 'Update Policy'
                  : 'Create Policy'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _savePolicy() {
    if (_formKey.currentState?.validate() ?? false) {
      final policy = {
        "id": widget.existingPolicy?["id"] ??
            DateTime.now().millisecondsSinceEpoch,
        "name": _nameController.text,
        "description": _descriptionController.text,
        "status": "inactive",
        "appliedDevices": 0,
        "lastModified": DateTime.now(),
        "settings": {
          "blockSocialMedia": _blockSocialMedia,
          "blockGames": _blockGames,
          "blockBrowser": _blockBrowser,
          "enableContentFilter": _enableContentFilter,
          "enableTimeRestrictions": _enableTimeRestrictions,
          "enableLocationTracking": _enableLocationTracking,
          "selectedApps": _selectedApps,
          "contentCategories": _contentCategories,
          "startTime": "${_startTime.hour}:${_startTime.minute}",
          "endTime": "${_endTime.hour}:${_endTime.minute}",
        },
      };

      widget.onPolicyCreated(policy);
      Navigator.pop(context);
    }
  }
}
