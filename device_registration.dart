import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/enrollment_faq_widget.dart';
import './widgets/enrollment_progress_widget.dart';
import './widgets/institution_branding_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/platform_notice_widget.dart';
import './widgets/qr_scanner_widget.dart';

class DeviceRegistration extends StatefulWidget {
  const DeviceRegistration({super.key});

  @override
  State<DeviceRegistration> createState() => _DeviceRegistrationState();
}

class _DeviceRegistrationState extends State<DeviceRegistration> {
  bool _isLoading = false;
  bool _showManualEntry = false;
  String? _errorMessage;
  String? _successMessage;

  // Mock enrollment data
  final List<Map<String, dynamic>> _mockEnrollmentCodes = [
    {
      'code': 'EDU-TECH-2024-DEMO-CODE-12345',
      'institution': 'EduTech Academy',
      'valid': true,
    },
    {
      'code': 'SCHOOL-MDM-2024-ADMIN-67890',
      'institution': 'Digital Learning Institute',
      'valid': true,
    },
    {
      'code': 'INVALID-CODE-TEST',
      'institution': null,
      'valid': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const InstitutionBrandingWidget(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EnrollmentProgressWidget(
                      currentStep: 1,
                      totalSteps: 4,
                    ),
                    SizedBox(height: 2.h),
                    _buildMainContent(),
                    SizedBox(height: 3.h),
                    const PlatformNoticeWidget(),
                    SizedBox(height: 2.h),
                    const EnrollmentFaqWidget(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Enrollment',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Scan the QR code provided by your institution or enter the enrollment code manually to begin device registration.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 3.h),
          if (_errorMessage != null) _buildErrorMessage(),
          if (_successMessage != null) _buildSuccessMessage(),
          SizedBox(height: 2.h),
          _showManualEntry
              ? _buildManualEntrySection()
              : _buildQrScannerSection(),
          SizedBox(height: 2.h),
          _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildQrScannerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'QR Code Scanner',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        QrScannerWidget(
          onCodeScanned: _handleCodeScanned,
        ),
      ],
    );
  }

  Widget _buildManualEntrySection() {
    return ManualEntryWidget(
      onCodeEntered: _handleCodeScanned,
      isLoading: _isLoading,
    );
  }

  Widget _buildToggleButton() {
    return Center(
      child: TextButton.icon(
        onPressed: _isLoading
            ? null
            : () {
                setState(() {
                  _showManualEntry = !_showManualEntry;
                  _errorMessage = null;
                  _successMessage = null;
                });
              },
        icon: CustomIconWidget(
          iconName: _showManualEntry ? 'qr_code_scanner' : 'keyboard',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        label: Text(
          _showManualEntry ? 'Use QR Scanner Instead' : 'Enter Code Manually',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 6.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.successColor,
            size: 6.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _successMessage!,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                'Back',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _successMessage != null && !_isLoading
                  ? _navigateToNextStep
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                'Continue to Policy Download',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCodeScanned(String code) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate server verification
      await Future.delayed(const Duration(seconds: 2));

      // Check if code is valid
      final enrollmentData = _mockEnrollmentCodes.firstWhere(
        (data) => (data['code'] as String).toUpperCase() == code.toUpperCase(),
        orElse: () => {'valid': false},
      );

      if (enrollmentData['valid'] == true) {
        setState(() {
          _successMessage =
              'Enrollment code verified successfully! Institution: ${enrollmentData['institution']}';
        });

        // Provide success haptic feedback
        HapticFeedback.mediumImpact();
      } else {
        setState(() {
          _errorMessage =
              'Invalid enrollment code. Please check the code and try again, or contact your IT administrator for assistance.';
        });

        // Provide error haptic feedback
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Network error occurred. Please check your internet connection and try again.';
      });

      HapticFeedback.heavyImpact();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToNextStep() {
    // Navigate to admin dashboard or policy management
    Navigator.pushReplacementNamed(context, '/admin-dashboard');
  }
}
