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
    _resetCompletedSessions();
  }
  Future<void> _resetCompletedSessions() async {
    final completed = await _firestore
        .collection('sessions')
        .where('status', isEqualTo: 'completed')
        .get();

    for (var doc in completed.docs) {
      await doc.reference.update({
        'status': 'upcoming',
        'duration': 0,
      });
    }
  }

  Future<void> _seedSessions() async {
    final snap = await _firestore.collection('sessions').get();
    if (snap.docs.isEmpty) {
      await _firestore.collection('sessions').add({
        'title': 'Flutter Video Call',
        'status': 'upcoming',
        'duration': 0,
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
