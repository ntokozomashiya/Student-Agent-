import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/policy_card_widget.dart';
import './widgets/policy_creation_sheet.dart';
import './widgets/policy_template_widget.dart';

class PolicyManagement extends StatefulWidget {
  const PolicyManagement({Key? key}) : super(key: key);

  @override
  State<PolicyManagement> createState() => _PolicyManagementState();
}

class _PolicyManagementState extends State<PolicyManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  // Mock data for policies
  List<Map<String, dynamic>> _policies = [
    {
      "id": 1,
      "name": "Classroom Standard",
      "description":
          "Basic classroom restrictions with social media blocking and content filtering for focused learning environment.",
      "status": "active",
      "appliedDevices": 45,
      "lastModified": DateTime.now().subtract(const Duration(days: 2)),
      "settings": {
        "blockSocialMedia": true,
        "blockGames": true,
        "enableContentFilter": true,
        "enableTimeRestrictions": false,
      }
    },
    {
      "id": 2,
      "name": "Exam Mode Lockdown",
      "description":
          "Strict policy for examination periods with complete app blocking and enhanced monitoring capabilities.",
      "status": "inactive",
      "appliedDevices": 0,
      "lastModified": DateTime.now().subtract(const Duration(days: 5)),
      "settings": {
        "blockSocialMedia": true,
        "blockGames": true,
        "blockBrowser": true,
        "enableContentFilter": true,
        "enableTimeRestrictions": true,
      }
    },
    {
      "id": 3,
      "name": "Study Hall Focus",
      "description":
          "Moderate restrictions allowing educational apps while blocking distracting content and social platforms.",
      "status": "active",
      "appliedDevices": 23,
      "lastModified": DateTime.now().subtract(const Duration(hours: 6)),
      "settings": {
        "blockSocialMedia": true,
        "blockGames": false,
        "enableContentFilter": true,
        "enableTimeRestrictions": true,
      }
    },
    {
      "id": 4,
      "name": "Break Time Relaxed",
      "description":
          "Minimal restrictions for break periods allowing most apps while maintaining basic safety filters.",
      "status": "pending",
      "appliedDevices": 12,
      "lastModified": DateTime.now().subtract(const Duration(days: 1)),
      "settings": {
        "blockSocialMedia": false,
        "blockGames": false,
        "enableContentFilter": true,
        "enableTimeRestrictions": false,
      }
    },
  ];

  // Mock data for policy templates
  final List<Map<String, dynamic>> _templates = [
    {
      "id": 1,
      "name": "Classroom Management",
      "description":
          "Standard classroom policy with app restrictions and content filtering for educational focus.",
      "category": "classroom",
      "features": [
        "Social Media Block",
        "Content Filter",
        "App Restrictions",
        "Time Limits"
      ]
    },
    {
      "id": 2,
      "name": "Exam Security",
      "description":
          "High-security policy for examination periods with complete device lockdown and monitoring.",
      "category": "exam",
      "features": [
        "Complete Lockdown",
        "Screen Monitoring",
        "App Blocking",
        "Communication Block"
      ]
    },
    {
      "id": 3,
      "name": "Study Mode",
      "description":
          "Focused learning environment with educational app access and distraction elimination.",
      "category": "study",
      "features": [
        "Educational Apps Only",
        "Distraction Block",
        "Focus Timer",
        "Progress Tracking"
      ]
    },
    {
      "id": 4,
      "name": "Break Time",
      "description":
          "Relaxed policy for break periods with limited restrictions and recreational app access.",
      "category": "break",
      "features": [
        "Recreational Apps",
        "Limited Restrictions",
        "Time-based",
        "Safe Browsing"
      ]
    },
    {
      "id": 5,
      "name": "Security Enhanced",
      "description":
          "Advanced security policy with comprehensive monitoring and threat protection.",
      "category": "security",
      "features": [
        "Threat Detection",
        "Advanced Monitoring",
        "VPN Block",
        "USB Restrictions"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Map<String, dynamic>> get _filteredPolicies {
    if (_searchQuery.isEmpty) return _policies;
    return _policies.where((policy) {
      final name = (policy["name"] as String? ?? "").toLowerCase();
      final description =
          (policy["description"] as String? ?? "").toLowerCase();
      return name.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredTemplates {
    if (_searchQuery.isEmpty) return _templates;
    return _templates.where((template) {
      final name = (template["name"] as String? ?? "").toLowerCase();
      final description =
          (template["description"] as String? ?? "").toLowerCase();
      final category = (template["category"] as String? ?? "").toLowerCase();
      return name.contains(_searchQuery) ||
          description.contains(_searchQuery) ||
          category.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPoliciesTab(),
                  _buildTemplatesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Policy Management',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showFilterOptions,
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'bulk_deploy',
              child: Text('Bulk Deploy'),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Text('Export Policies'),
            ),
            const PopupMenuItem(
              value: 'import',
              child: Text('Import Policies'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Policy Settings'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search policies and templates...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.outlineLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.outlineLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.primaryLight,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineLight.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textMediumEmphasisLight,
        labelStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'policy',
                  color: _tabController.index == 0
                      ? Colors.white
                      : AppTheme.textMediumEmphasisLight,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                const Text('Policies'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'template_library',
                  color: _tabController.index == 1
                      ? Colors.white
                      : AppTheme.textMediumEmphasisLight,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                const Text('Templates'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoliciesTab() {
    final filteredPolicies = _filteredPolicies;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredPolicies.isEmpty) {
      return _buildEmptyState(
        icon: 'policy',
        title:
            _searchQuery.isEmpty ? 'No Policies Created' : 'No Policies Found',
        subtitle: _searchQuery.isEmpty
            ? 'Create your first policy to start managing devices'
            : 'Try adjusting your search terms',
        actionText: _searchQuery.isEmpty ? 'Create Policy' : null,
        onAction: _searchQuery.isEmpty ? _showCreatePolicySheet : null,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPolicies,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
        itemCount: filteredPolicies.length,
        itemBuilder: (context, index) {
          final policy = filteredPolicies[index];
          return PolicyCardWidget(
            policy: policy,
            onEdit: () => _editPolicy(policy),
            onDuplicate: () => _duplicatePolicy(policy),
            onDeploy: () => _togglePolicyStatus(policy),
            onDelete: () => _deletePolicy(policy),
            onTap: () => _viewPolicyDetails(policy),
          );
        },
      ),
    );
  }

  Widget _buildTemplatesTab() {
    final filteredTemplates = _filteredTemplates;

    if (filteredTemplates.isEmpty) {
      return _buildEmptyState(
        icon: 'template_library',
        title: 'No Templates Found',
        subtitle: 'Try adjusting your search terms',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      itemCount: filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = filteredTemplates[index];
        return PolicyTemplateWidget(
          template: template,
          onTap: () => _useTemplate(template),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required String icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.outlineLight.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.textDisabledLight,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showCreatePolicySheet,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
      label: Text(
        'Create Policy',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.primaryLight,
    );
  }

  void _showCreatePolicySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PolicyCreationSheet(
        onPolicyCreated: _addPolicy,
      ),
    );
  }

  void _editPolicy(Map<String, dynamic> policy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PolicyCreationSheet(
        existingPolicy: policy,
        onPolicyCreated: _updatePolicy,
      ),
    );
  }

  void _duplicatePolicy(Map<String, dynamic> policy) {
    final duplicatedPolicy = Map<String, dynamic>.from(policy);
    duplicatedPolicy["id"] = DateTime.now().millisecondsSinceEpoch;
    duplicatedPolicy["name"] = "${policy["name"]} (Copy)";
    duplicatedPolicy["status"] = "inactive";
    duplicatedPolicy["appliedDevices"] = 0;
    duplicatedPolicy["lastModified"] = DateTime.now();

    setState(() {
      _policies.add(duplicatedPolicy);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Policy "${policy["name"]}" duplicated successfully'),
        action: SnackBarAction(
          label: 'Edit',
          onPressed: () => _editPolicy(duplicatedPolicy),
        ),
      ),
    );
  }

  void _togglePolicyStatus(Map<String, dynamic> policy) {
    final currentStatus = policy["status"] as String;
    final newStatus = currentStatus == "active" ? "inactive" : "active";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${newStatus == "active" ? "Deploy" : "Pause"} Policy',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          newStatus == "active"
              ? 'Deploy "${policy["name"]}" to selected devices?'
              : 'Pause "${policy["name"]}" on all devices?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                policy["status"] = newStatus;
                policy["lastModified"] = DateTime.now();
                if (newStatus == "active") {
                  policy["appliedDevices"] = 25; // Mock device count
                } else {
                  policy["appliedDevices"] = 0;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Policy ${newStatus == "active" ? "deployed" : "paused"} successfully',
                  ),
                ),
              );
            },
            child: Text(newStatus == "active" ? "Deploy" : "Pause"),
          ),
        ],
      ),
    );
  }

  void _deletePolicy(Map<String, dynamic> policy) {
    setState(() {
      _policies.removeWhere((p) => p["id"] == policy["id"]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Policy "${policy["name"]}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _policies.add(policy);
            });
          },
        ),
      ),
    );
  }

  void _viewPolicyDetails(Map<String, dynamic> policy) {
    Navigator.pushNamed(context, '/policy-detail', arguments: policy);
  }

  void _useTemplate(Map<String, dynamic> template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PolicyCreationSheet(
        existingPolicy: {
          "name": template["name"],
          "description": template["description"],
          "settings": _getTemplateSettings(template["category"] as String),
        },
        onPolicyCreated: _addPolicy,
      ),
    );
  }

  Map<String, dynamic> _getTemplateSettings(String category) {
    switch (category) {
      case 'classroom':
        return {
          "blockSocialMedia": true,
          "blockGames": true,
          "enableContentFilter": true,
          "enableTimeRestrictions": false,
        };
      case 'exam':
        return {
          "blockSocialMedia": true,
          "blockGames": true,
          "blockBrowser": true,
          "enableContentFilter": true,
          "enableTimeRestrictions": true,
        };
      case 'study':
        return {
          "blockSocialMedia": true,
          "blockGames": false,
          "enableContentFilter": true,
          "enableTimeRestrictions": true,
        };
      case 'break':
        return {
          "blockSocialMedia": false,
          "blockGames": false,
          "enableContentFilter": true,
          "enableTimeRestrictions": false,
        };
      default:
        return {
          "blockSocialMedia": false,
          "blockGames": false,
          "enableContentFilter": false,
          "enableTimeRestrictions": false,
        };
    }
  }

  void _addPolicy(Map<String, dynamic> policy) {
    setState(() {
      _policies.add(policy);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Policy "${policy["name"]}" created successfully'),
        action: SnackBarAction(
          label: 'Deploy',
          onPressed: () => _togglePolicyStatus(policy),
        ),
      ),
    );
  }

  void _updatePolicy(Map<String, dynamic> updatedPolicy) {
    setState(() {
      final index = _policies.indexWhere((p) => p["id"] == updatedPolicy["id"]);
      if (index != -1) {
        _policies[index] = updatedPolicy;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Policy "${updatedPolicy["name"]}" updated successfully'),
      ),
    );
  }

  Future<void> _refreshPolicies() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Policies',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successColor,
                size: 24,
              ),
              title: const Text('Active Policies'),
              onTap: () {
                Navigator.pop(context);
                // Apply filter logic
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'pause_circle',
                color: AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
              title: const Text('Inactive Policies'),
              onTap: () {
                Navigator.pop(context);
                // Apply filter logic
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.warningColor,
                size: 24,
              ),
              title: const Text('Pending Policies'),
              onTap: () {
                Navigator.pop(context);
                // Apply filter logic
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'bulk_deploy':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bulk deploy feature coming soon')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export policies feature coming soon')),
        );
        break;
      case 'import':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Import policies feature coming soon')),
        );
        break;
      case 'settings':
        Navigator.pushNamed(context, '/policy-settings');
        break;
    }
  }
}
