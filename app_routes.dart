import 'package:flutter/material.dart';
import '../presentation/device_detail/device_detail.dart';
import '../presentation/device_list/device_list.dart';
import '../presentation/device_registration/device_registration.dart';
import '../presentation/policy_management/policy_management.dart';
import '../presentation/remote_control/remote_control.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String deviceDetail = '/device-detail';
  static const String deviceList = '/device-list';
  static const String deviceRegistration = '/device-registration';
  static const String policyManagement = '/policy-management';
  static const String remoteControl = '/remote-control';
  static const String adminDashboard = '/admin-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DeviceDetail(),
    deviceDetail: (context) => const DeviceDetail(),
    deviceList: (context) => const DeviceList(),
    deviceRegistration: (context) => const DeviceRegistration(),
    policyManagement: (context) => const PolicyManagement(),
    remoteControl: (context) => const RemoteControl(),
    adminDashboard: (context) => const AdminDashboard(),
    // TODO: Add your other routes here
  };
}
