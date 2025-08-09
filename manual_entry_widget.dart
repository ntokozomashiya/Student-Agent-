import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ManualEntryWidget extends StatefulWidget {
  final Function(String) onCodeEntered;
  final bool isLoading;

  const ManualEntryWidget({
    super.key,
    required this.onCodeEntered,
    this.isLoading = false,
  });

  @override
  State<ManualEntryWidget> createState() => _ManualEntryWidgetState();
}

class _ManualEntryWidgetState extends State<ManualEntryWidget> {
  final TextEditingController _codeController = TextEditingController();
  bool _isValidCode = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _validateCode() {
    final code = _codeController.text.trim();
    final isValid =
        code.length >= 10 && RegExp(r'^[A-Z0-9\-]+$').hasMatch(code);

    if (_isValidCode != isValid) {
      setState(() {
        _isValidCode = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manual Entry',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Enter the enrollment code provided by your institution',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: _codeController,
            enabled: !widget.isLoading,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
              LengthLimitingTextInputFormatter(50),
            ],
            decoration: InputDecoration(
              labelText: 'Enrollment Code',
              hintText: 'EDU-TECH-2024-XXXX-XXXXX',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'qr_code',
                  color: _isValidCode
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              suffixIcon: _isValidCode
                  ? Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successColor,
                        size: 6.w,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValidCode && !widget.isLoading
                  ? () => widget.onCodeEntered(_codeController.text.trim())
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      'Verify Code',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Code format: Letters, numbers, and hyphens only (minimum 10 characters)',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
