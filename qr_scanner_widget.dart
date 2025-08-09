import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QrScannerWidget extends StatefulWidget {
  final Function(String) onCodeScanned;

  const QrScannerWidget({
    super.key,
    required this.onCodeScanned,
  });

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isScanning = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        setState(() {
          _errorMessage = 'Camera permission is required to scan QR codes';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available on this device';
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      if (!kIsWeb) {
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Ignore focus/flash errors on unsupported devices
        }
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera';
      });
    }
  }

  Future<void> _simulateQrScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    // Simulate QR code detection for demo purposes
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      widget.onCodeScanned('EDU-TECH-2024-DEMO-CODE-12345');
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: _buildCameraContent(),
      ),
    );
  }

  Widget _buildCameraContent() {
    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (!_isInitialized || _cameraController == null) {
      return _buildLoadingState();
    }

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_cameraController!),
        ),
        _buildScanOverlay(),
        if (_isScanning) _buildScanningIndicator(),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage!,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _initializeCamera();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Initializing camera...',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Dark overlay
          Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
          // Scan area cutout
          Center(
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  Positioned(
                    top: -1,
                    left: -1,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.w),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(2.w),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    left: -1,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(2.w),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(2.w),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Column(
                  children: [
                    Text(
                      'Position QR code within the frame',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    ElevatedButton(
                      onPressed: _simulateQrScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_isScanning ? 'Scanning...' : 'Scan QR Code'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Scanning QR Code...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
