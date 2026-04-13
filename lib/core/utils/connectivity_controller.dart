// lib/features/auth/controllers/connectivity_controller.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  bool isConnected = true;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listenToConnectivity();
    checkConnectivity();
  }

  void _listenToConnectivity() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final connected = results.any((r) => r != ConnectivityResult.none);
      if (isConnected != connected) {
        isConnected = connected;
        update();
      }
    });
  }

  Future<void> checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final connected = results.any((r) => r != ConnectivityResult.none);
    if (isConnected != connected) {
      isConnected = connected;
      update();
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
