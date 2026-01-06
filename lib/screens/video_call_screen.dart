import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/session_controller.dart';

class VideoCallScreen extends StatefulWidget {
  final String sessionId;
  const VideoCallScreen({super.key, required this.sessionId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final controller = Get.find<SessionController>();

  CameraController? _camera;
  List<CameraDescription>? _cameras;
  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _camera = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.medium,
    );
    await _camera!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras!.length;
    await _camera?.dispose();
    await _initCamera();
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _camera == null || !_camera!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CameraPreview(_camera!),
              ),
            ),

            const SizedBox(height: 12),

            Obx(() => Text(
              controller.formattedTime,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            )),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.cameraswitch,
                      color: Colors.white, size: 32),
                  onPressed: _switchCamera,
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call'),
                  onPressed: () async {
                    await controller.endSession(widget.sessionId);
                    Get.back();
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
