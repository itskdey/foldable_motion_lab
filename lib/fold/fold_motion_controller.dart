import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class FoldMotionController extends ChangeNotifier {
  FoldMotionController({
    required TickerProvider vsync,
    this.expandedBreakpoint = 600,
  }) : animationController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 700),
          reverseDuration: const Duration(milliseconds: 700),
        ) {
    animationController.addListener(notifyListeners);
  }

  final AnimationController animationController;
  final double expandedBreakpoint;

  bool _autoDevice = true;
  bool _initialized = false;
  bool? _lastExpanded;

  bool get autoDevice => _autoDevice;
  double get progress => animationController.value;

  static const Curve motionCurve = Curves.fastOutSlowIn;

  void initializeForWidth(double width) {
    if (_initialized) return;

    _initialized = true;
    final expanded = width >= expandedBreakpoint;
    _lastExpanded = expanded;
    animationController.value = expanded ? 1 : 0;
  }

  void syncToDeviceWidth(double width) {
    if (!_autoDevice) return;

    final expanded = width >= expandedBreakpoint;

    if (!_initialized) {
      initializeForWidth(width);
      return;
    }

    if (_lastExpanded == expanded) {
      return;
    }

    _lastExpanded = expanded;

    animationController.animateTo(
      expanded ? 1 : 0,
      duration: const Duration(milliseconds: 700),
      curve: motionCurve,
    );
  }

  void setAutoDevice(bool value) {
    if (_autoDevice == value) return;
    _autoDevice = value;
    notifyListeners();
  }

  void setProgress(double value) {
    _autoDevice = false;
    animationController.value = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  Future<void> fold() async {
    _autoDevice = false;
    await animationController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: motionCurve,
    );
  }

  Future<void> unfold() async {
    _autoDevice = false;
    await animationController.animateTo(
      1,
      duration: const Duration(milliseconds: 700),
      curve: motionCurve,
    );
  }

  @override
  void dispose() {
    animationController.removeListener(notifyListeners);
    animationController.dispose();
    super.dispose();
  }
}
