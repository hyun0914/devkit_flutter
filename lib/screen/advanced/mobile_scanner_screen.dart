import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/default_scaffold.dart';

class MobileScannerScreen extends StatefulWidget {
  const MobileScannerScreen({super.key});

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasPermission = false;
  bool _isScanning = false;
  String? _scannedValue;
  BarcodeType? _scannedType;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    setState(() => _hasPermission = status.isGranted);
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    setState(() => _hasPermission = status.isGranted);
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() {
      _scannedValue = barcode!.rawValue;
      _scannedType = barcode.type;
      _isScanning = false;
    });
    _controller.stop();
  }

  void _startScan() {
    setState(() {
      _scannedValue = null;
      _scannedType = null;
      _isScanning = true;
    });
    _controller.start();
  }

  void _stopScan() {
    setState(() => _isScanning = false);
    _controller.stop();
  }

  String _typeName(BarcodeType? type) {
    switch (type) {
      case BarcodeType.url:
        return 'URL';
      case BarcodeType.text:
        return '텍스트';
      case BarcodeType.wifi:
        return 'Wi-Fi';
      case BarcodeType.email:
        return '이메일';
      case BarcodeType.phone:
        return '전화번호';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('QR / 바코드 스캔'),
        actions: [
          if (_isScanning)
            IconButton(
              icon: const Icon(Icons.flash_on_rounded),
              onPressed: () => _controller.toggleTorch(),
              tooltip: '플래시',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 카메라 뷰
            Expanded(
              flex: 3,
              child: _hasPermission
                  ? _buildScannerView(theme)
                  : _buildPermissionView(theme),
            ),

            // 결과 & 컨트롤
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 결과
                    Expanded(child: _buildResult(theme)),

                    const SizedBox(height: 16),

                    // 버튼
                    if (_hasPermission)
                      _isScanning
                          ? OutlinedButton.icon(
                              onPressed: _stopScan,
                              icon: const Icon(Icons.stop_rounded),
                              label: const Text('스캔 중지'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                foregroundColor: theme.colorScheme.error,
                                side: BorderSide(
                                    color: theme.colorScheme.error),
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: _startScan,
                              icon: const Icon(Icons.qr_code_scanner_rounded),
                              label: const Text('스캔 시작'),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                            ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView(ThemeData theme) {
    if (!_isScanning) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_rounded, size: 80, color: Colors.white38),
              const SizedBox(height: 16),
              Text(
                '스캔 시작 버튼을 눌러주세요',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
        ),
        // 스캔 가이드 오버레이
        Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.primary, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Text(
            'QR 코드나 바코드를 사각형 안에 맞춰주세요',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.white, shadows: [
              const Shadow(color: Colors.black, blurRadius: 4),
            ]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_rounded,
                size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              '카메라 권한이 필요합니다',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'QR/바코드 스캔을 위해 카메라 접근을 허용해주세요.',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _requestPermission,
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('권한 허용'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(ThemeData theme) {
    if (_scannedValue == null) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            '스캔 결과가 여기에 표시됩니다',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                '스캔 성공 · ${_typeName(_scannedType)}',
                style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _scannedValue!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
