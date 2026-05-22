import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/default_scaffold.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _hasPermission = false;
  bool _isInitialized = false;
  bool _isTakingPicture = false;
  File? _capturedImage;
  int _cameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera(_cameras[_cameraIndex]);
    }
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _hasPermission = false);
      return;
    }
    setState(() => _hasPermission = true);

    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      await _setupCamera(_cameras[_cameraIndex]);
    }
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = controller;

    try {
      await controller.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() => _isTakingPicture = true);

    try {
      final file = await _controller!.takePicture();
      setState(() {
        _capturedImage = File(file.path);
        _isTakingPicture = false;
      });
    } catch (e) {
      setState(() => _isTakingPicture = false);
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    setState(() => _isInitialized = false);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _controller?.dispose();
    await _setupCamera(_cameras[_cameraIndex]);
  }

  Future<void> _toggleFlash() async {
    final next = _flashMode == FlashMode.off
        ? FlashMode.always
        : _flashMode == FlashMode.always
            ? FlashMode.auto
            : FlashMode.off;
    await _controller?.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  IconData get _flashIcon {
    switch (_flashMode) {
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      default:
        return Icons.flash_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('카메라')),
      body: SafeArea(
        child: Column(
          children: [
            // 카메라 뷰
            Expanded(
              flex: 3,
              child: _buildCameraView(theme),
            ),

            // 컨트롤
            Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: _capturedImage != null
                  ? _buildCapturedControls(theme)
                  : _buildCameraControls(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView(ThemeData theme) {
    if (!_hasPermission) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_rounded,
                  size: 64, color: Colors.white38),
              const SizedBox(height: 16),
              const Text('카메라 권한이 필요합니다',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _initCamera,
                child: const Text('권한 요청'),
              ),
            ],
          ),
        ),
      );
    }

    if (_capturedImage != null) {
      return Image.file(_capturedImage!, fit: BoxFit.cover, width: double.infinity);
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return CameraPreview(_controller!);
  }

  Widget _buildCameraControls(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 플래시
        IconButton(
          icon: Icon(_flashIcon, color: Colors.white, size: 28),
          onPressed: _toggleFlash,
        ),

        // 촬영
        GestureDetector(
          onTap: _isTakingPicture ? null : _takePicture,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              color: _isTakingPicture
                  ? Colors.white38
                  : Colors.white.withValues(alpha: 0.2),
            ),
            child: _isTakingPicture
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : null,
          ),
        ),

        // 카메라 전환
        IconButton(
          icon: const Icon(Icons.flip_camera_ios_rounded,
              color: Colors.white, size: 28),
          onPressed: _cameras.length >= 2 ? _switchCamera : null,
        ),
      ],
    );
  }

  Widget _buildCapturedControls(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _capturedImage = null),
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          label:
              const Text('다시 찍기', style: TextStyle(color: Colors.white)),
        ),
        TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('저장됨: ${_capturedImage!.path}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.save_rounded, color: Colors.greenAccent),
          label: const Text('저장',
              style: TextStyle(color: Colors.greenAccent)),
        ),
      ],
    );
  }
}
