import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  int _count = 0;
  bool isMounted = true;
  Timer? _timer;

  int get count => _count;

  void _emit(int value) {
    _count = value;
    if (isMounted) notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = null;
    if (!isMounted) return;
    _emit(0);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isMounted) return;
      _emit(t.tick);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    if (!isMounted) return;
    _emit(0);
  }

  void changePageIndex({required int index}) {
    _emit(index);
  }

  void reloadState() {
    _emit(Random().nextInt(10000));
  }

  void increment() {
    _emit(_count + 1);
  }

  void resetCounter() {
    _emit(0);
  }

  void addCounterIndex(int index) {
    _emit(index);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
