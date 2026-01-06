import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt secondsElapsed = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _seedSessions();

  }
  Future<void> _seedSessions() async {
    final activeSessions = await _firestore
        .collection('sessions')
        .where('status', whereIn: ['upcoming', 'ongoing'])
        .get();

    if (activeSessions.docs.isEmpty) {
      await _firestore.collection('sessions').add({
        'title': 'Flutter Video Call',
        'status': 'upcoming',
        'duration': 0,
        'createdAt': Timestamp.now(),
      });
    }
  }



  Stream<QuerySnapshot> getSessions() {
    return _firestore
        .collection('sessions')
        .where('status', whereIn: ['upcoming', 'ongoing'])
        .snapshots();
  }

  Future<void> startSession(String id) async {
    secondsElapsed.value = 0;

    await _firestore.collection('sessions').doc(id).update({
      'status': 'ongoing',
      'startTime': Timestamp.now(),
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      secondsElapsed.value++;
    });
  }

  Future<void> endSession(String id) async {
    _timer?.cancel();

    await _firestore.collection('sessions').doc(id).update({
      'status': 'completed',
      'duration': secondsElapsed.value,
      'endTime': Timestamp.now(),
    });
  }

  String get formattedTime {
    final m = secondsElapsed.value ~/ 60;
    final s = secondsElapsed.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
