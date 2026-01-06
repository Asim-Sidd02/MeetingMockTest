import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/session_controller.dart';
import 'video_call_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({super.key});

  final controller = Get.put(SessionController());

  Future<bool> _checkPermissions() async {
    var cam = await Permission.camera.request();
    var mic = await Permission.microphone.request();
    return cam.isGranted && mic.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Sessions'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: controller.getSessions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No sessions available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final s = docs[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(s['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Status: ${s['status']}'),
                  trailing: FilledButton(
                    child: const Text('Join'),
                    onPressed: () async {
                      final ok = await _checkPermissions();
                      if (!ok) {
                        Get.snackbar('Permission required',
                            'Camera & Mic access needed');
                        return;
                      }

                      await controller.startSession(s.id);
                      Get.to(() => VideoCallScreen(sessionId: s.id));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
