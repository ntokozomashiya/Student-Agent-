import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/device_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_filter_bar_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({Key? key}) : super(key: key);

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedDevices = <String>{};

  String _currentFilter = 'All';
  String _currentSort = 'Name';
  String _searchQuery = '';
  bool _isRefreshing = false;
  bool _isMultiSelectMode = false;

  late TabController _tabController;

  // Mock device data
  final List<Map<String, dynamic>> _allDevices = [
    {
      "id": "dev_001",
      "deviceName": "iPad Pro - Classroom A1",
      "studentName": "Emma Johnson",
      "status": "Online",
      "lastSeen": DateTime.now().subtract(const Duration(minutes: 5)),
      "batteryLevel": 85,
      "deviceType": "Tablet",
      "policyGroup": "Standard",
      "location": "Building A - Room 101",
    },
    {
      "id": "dev_002",
      "deviceName": "Samsung Galaxy Tab S8",
      "studentName": "Michael Chen",
      "status": "Warning",
      "lastSeen": DateTime.now().subtract(const Duration(minutes: 15)),
      "batteryLevel": 45,
      "deviceType": "Tablet",
      "policyGroup": "Restricted",
      "location": "Building B - Room 205",
    },
    {
      "id": "dev_003",
      "deviceName": "iPad Air - Student Device",
      "studentName": "Sarah Williams",
      "status": "Offline",
      "lastSeen": DateTime.now().subtract(const Duration(hours: 2)),
      "batteryLevel": 12,
      "deviceType": "Tablet",
      "policyGroup": "Standard",
      "location": "Building A - Room 103",
    },
    {
      "id": "dev_004",
      "deviceName": "Lenovo Tab M10",
      "studentName": "David Rodriguez",
      "status": "Online",
      "lastSeen": DateTime.now().subtract(const Duration(minutes: 2)),
      "batteryLevel": 92,
      "deviceType": "Tablet",
      "policyGroup": "Advanced",
      "location": "Building C - Room 301",
    },
    {
      "id": "dev_005",
      "deviceName": "iPhone 13 - Student",
      "studentName": "Jessica Brown",
      "status": "Online",
      "lastSeen": DateTime.now().subtract(const Duration(minutes: 1)),
      "batteryLevel": 78,
      "deviceType": "Phone",
      "policyGroup": "Standard",
      "location": "Building A - Room 102",
    },
    {
      "id": "dev_006",
      "deviceName": "Samsung Galaxy A54",
      "studentName": "Alex Thompson",
      "status": "Warning",
      "lastSeen": DateTime.now().subtract(const Duration(minutes: 30)),
      "batteryLevel": 25,
      "deviceType": "Phone",
      "policyGroup": "Restricted",
      "location": "Building B - Room 210",
    },
    {
      "id": "dev_007",
      "deviceName": "iPad Mini - Library",
      "studentName": "Olivia Davis",
      "status": "Offline",
      "lastSeen": DateTime.now().subtract(const Duration(hours: 4)),
      "batteryLevel": 8,
      "deviceType": "Tablet",
      "policyGroup": "Standard",
      "location": "Library - Study Area",
    },
    {
      "id": "dev_008",
      "deviceName": "Surface Go 3",
      "studentName": "Ryan Martinez",
      "status": "Online",
      "lastSeen": DateTime.now().subtract(const Duration(seconds: 30)),
      "batteryLevel": 95,
      "deviceType": "Tablet",
      "policyGroup": "Advanced",
      "location": "Building C - Room 305",
    },
  ];

  List<Map<String, dynamic>> _filteredDevices = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 2);
    _filteredDevices = List.from(_allDevices);
    _applyFiltersAndSort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            _buildSearchFilterBar(),
            Expanded(
              child: Stack(
                children: [
                  _buildDeviceList(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BulkActionsWidget(
                      selectedCount: _selectedDevices.length,
                      onLockSelected: _lockSelectedDevices,
                      onSendBroadcast: _sendBroadcastMessage,
                      onApplyPolicy: _applyPolicyToSelected,
                      onClearSelection: _clearSelection,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Registration'),
          Tab(text: 'Devices'),
          Tab(text: 'Details'),
          Tab(text: 'Policies'),
          Tab(text: 'Remote'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/admin-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/device-registration');
              break;
            case 2:
              // Current screen - do nothing
              break;
            case 3:
              Navigator.pushNamed(context, '/device-detail');
              break;
            case 4:
              Navigator.pushNamed(context, '/policy-management');
              break;
            case 5:
              Navigator.pushNamed(context, '/remote-control');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSearchFilterBar() {
    return SearchFilterBarWidget(
      searchController: _searchController,
      onSearchChanged: _onSearchChanged,
      onFilterTap: _showFilterBottomSheet,
      onSortTap: _showSortBottomSheet,
      currentFilter: _currentFilter,
      currentSort: _currentSort,
    );
  }

  Widget _buildDeviceList() {
    if (_filteredDevices.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshDevices,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 2.h,
          bottom: _selectedDevices.isNotEmpty ? 18.h : 2.h,
        ),
        itemCount: _filteredDevices.length,
        itemBuilder: (context, index) {
          final device = _filteredDevices[index];
          final deviceId = device["id"] as String;
          final isSelected = _selectedDevices.contains(deviceId);

          return DeviceCardWidget(
            device: device,
            isSelected: isSelected,
            onTap: () => _onDeviceCardTap(deviceId),
            onLongPress: () => _onDeviceCardLongPress(deviceId),
            onSwipeAction: (action) => _handleSwipeAction(deviceId, action),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String emptyStateType;

    if (_searchQuery.isNotEmpty) {
      emptyStateType = 'search_results';
    } else if (_currentFilter != 'All') {
      emptyStateType = 'filter_results';
    } else if (_allDevices.isEmpty) {
      emptyStateType = 'no_devices';
    } else {
      emptyStateType = 'no_devices';
    }

    return EmptyStateWidget(
      type: emptyStateType,
      onAddDevice:
          emptyStateType == 'no_devices' ? _navigateToDeviceRegistration : null,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSort();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilter: _currentFilter,
        onFilterChanged: (filter) {
          setState(() {
            _currentFilter = filter;
          });
          _applyFiltersAndSort();
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _applyFiltersAndSort();
        },
      ),
    );
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allDevices);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((device) {
        final deviceName = (device["deviceName"] as String).toLowerCase();
        final studentName = (device["studentName"] as String).toLowerCase();
        final status = (device["status"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return deviceName.contains(query) ||
            studentName.contains(query) ||
            status.contains(query);
      }).toList();
    }

    // Apply status/type filter
    if (_currentFilter != 'All') {
      filtered = filtered.where((device) {
        switch (_currentFilter) {
          case 'Online':
            return (device["status"] as String).toLowerCase() == 'online';
          case 'Offline':
            return (device["status"] as String).toLowerCase() == 'offline';
          case 'Tablet':
            return (device["deviceType"] as String).toLowerCase() == 'tablet';
          case 'Phone':
            return (device["deviceType"] as String).toLowerCase() == 'phone';
          case 'Managed':
            return (device["policyGroup"] as String) != 'None';
          case 'Unmanaged':
            return (device["policyGroup"] as String) == 'None';
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      switch (_currentSort) {
        case 'Name':
          return (a["deviceName"] as String)
              .compareTo(b["deviceName"] as String);
        case 'Student':
          return (a["studentName"] as String)
              .compareTo(b["studentName"] as String);
        case 'LastSeen':
          return (b["lastSeen"] as DateTime)
              .compareTo(a["lastSeen"] as DateTime);
        case 'Battery':
          return (b["batteryLevel"] as int).compareTo(a["batteryLevel"] as int);
        case 'Status':
          return (a["status"] as String).compareTo(b["status"] as String);
        default:
          return 0;
      }
    });

    setState(() {
      _filteredDevices = filtered;
    });
  }

  Future<void> _refreshDevices() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isRefreshing = false;
    });

    _applyFiltersAndSort();
  }

  void _onDeviceCardTap(String deviceId) {
    if (_isMultiSelectMode) {
      _toggleDeviceSelection(deviceId);
    } else {
      Navigator.pushNamed(context, '/device-detail', arguments: deviceId);
    }
  }

  void _onDeviceCardLongPress(String deviceId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isMultiSelectMode = true;
    });
    _toggleDeviceSelection(deviceId);
  }

  void _toggleDeviceSelection(String deviceId) {
    setState(() {
      if (_selectedDevices.contains(deviceId)) {
        _selectedDevices.remove(deviceId);
        if (_selectedDevices.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedDevices.add(deviceId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedDevices.clear();
      _isMultiSelectMode = false;
    });
  }

  void _handleSwipeAction(String deviceId, String action) {
    switch (action) {
      case 'lock':
        _lockDevice(deviceId);
        break;
      case 'message':
        _sendMessageToDevice(deviceId);
        break;
      case 'locate':
        _locateDevice(deviceId);
        break;
      case 'restart':
        _restartDevice(deviceId);
        break;
      case 'remove':
        _removeDeviceFromGroup(deviceId);
        break;
    }
  }

  void _lockDevice(String deviceId) {
    final device = _allDevices.firstWhere((d) => d["id"] == deviceId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Locking ${device["deviceName"]}...'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo lock action
          },
        ),
      ),
    );
  }

  void _sendMessageToDevice(String deviceId) {
    final device = _allDevices.firstWhere((d) => d["id"] == deviceId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Send a message to ${device["deviceName"]}'),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Message sent to ${device["deviceName"]}')),
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _locateDevice(String deviceId) {
    final device = _allDevices.firstWhere((d) => d["id"] == deviceId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Locating ${device["deviceName"]}...'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _restartDevice(String deviceId) {
    final device = _allDevices.firstWhere((d) => d["id"] == deviceId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restart Device'),
        content: Text(
            'Are you sure you want to restart ${device["deviceName"]}? This will interrupt any ongoing activities.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Restarting ${device["deviceName"]}...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  void _removeDeviceFromGroup(String deviceId) {
    final device = _allDevices.firstWhere((d) => d["id"] == deviceId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Device'),
        content: Text('Remove ${device["deviceName"]} from the current group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('${device["deviceName"]} removed from group')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _lockSelectedDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lock Selected Devices'),
        content: Text('Lock ${_selectedDevices.length} selected devices?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Locking ${_selectedDevices.length} devices...')),
              );
              _clearSelection();
            },
            child: Text('Lock All'),
          ),
        ],
      ),
    );
  }

  void _sendBroadcastMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Broadcast Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Send a message to ${_selectedDevices.length} selected devices'),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter broadcast message...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Broadcast sent to ${_selectedDevices.length} devices')),
              );
              _clearSelection();
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _applyPolicyToSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply Policy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Apply policy to ${_selectedDevices.length} selected devices'),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Policy',
                border: OutlineInputBorder(),
              ),
              items: ['Standard', 'Restricted', 'Advanced', 'Exam Mode']
                  .map((policy) => DropdownMenuItem(
                        value: policy,
                        child: Text(policy),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Policy applied to ${_selectedDevices.length} devices')),
              );
              _clearSelection();
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _navigateToDeviceRegistration() {
    Navigator.pushNamed(context, '/device-registration');
  }
}
