import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class WebCameraScreen extends StatefulWidget {
  const WebCameraScreen({super.key});

  @override
  State<WebCameraScreen> createState() =>
      _WebCameraScreenState();
}

class _WebCameraScreenState
    extends State<WebCameraScreen> {
  CameraController? _controller;

  bool _loading = true;
  bool _capturing = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    CameraController? controller;

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw StateError(
          'No camera was found on this device.',
        );
      }

      if (!mounted) return;

      controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (_) {
      await controller?.dispose();

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error =
            'Could not open the camera. '
            'Allow camera access in Chrome '
            'and make sure your webcam is available.';
      });
    }
  }

  Future<void> _capture() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _capturing) {
      return;
    }

    setState(() => _capturing = true);

    try {
      final photo = await controller.takePicture();

      if (!mounted) return;

      Navigator.of(context).pop(photo);
    } catch (_) {
      if (!mounted) return;

      setState(() => _capturing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not capture the photo. Try again.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17251F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF17251F),
        foregroundColor: Colors.white,
        title: const Text('Capture a moment'),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: _buildPreview(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (!_loading && _error == null)
                    const Text(
                      'Make this moment yours.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (!_loading && _error == null)
                    SizedBox(
                      width: 76,
                      height: 76,

                      child: IconButton.filled(
                        onPressed:
                            _capturing ? null : _capture,

                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color(0xFF315E48),
                        ),

                        icon: _capturing
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.camera_alt,
                                size: 32,
                              ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(),

                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_loading) {
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.no_photography_outlined,
            color: Colors.white70,
            size: 54,
          ),

          const SizedBox(height: 20),

          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              height: 1.6,
            ),
          ),
        ],
      );
    }

    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: CameraPreview(controller),
    );
  }
}