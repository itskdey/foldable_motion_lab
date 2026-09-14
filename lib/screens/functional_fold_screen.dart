import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../fold/fold_device_info.dart';
import '../fold/fold_motion_controller.dart';
import '../models/lab_action.dart';
import '../state/fold_lab_store.dart';
import '../widgets/fold_detail_panel.dart';
import '../widgets/fold_home_panel.dart';
import '../widgets/fold_simulator_bar.dart';

class FunctionalFoldScreen extends StatefulWidget {
  const FunctionalFoldScreen({super.key});

  @override
  State<FunctionalFoldScreen> createState() => _FunctionalFoldScreenState();
}

class _FunctionalFoldScreenState extends State<FunctionalFoldScreen>
    with TickerProviderStateMixin {
  late final FoldMotionController motion;
  late final AnimationController detail;
  late final FoldLabStore store;

  @override
  void initState() {
    super.initState();
    motion = FoldMotionController(vsync: this, expandedBreakpoint: 600);
    detail = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
      reverseDuration: const Duration(milliseconds: 360),
    );
    store = FoldLabStore();
  }

  @override
  void dispose() {
    motion.dispose();
    detail.dispose();
    store.dispose();
    super.dispose();
  }

  void openAction(LabActionType type) {
    store.selectAction(type);
    detail.animateTo(1, curve: Curves.easeOutCubic);
  }

  void closeAction() {
    detail.animateTo(0, curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final device = FoldDeviceInfo.fromMediaQuery(media);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, outer) {
            motion.initializeForWidth(
              outer.maxWidth,
              hasPhysicalFold: device.hasPhysicalFold,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              motion.syncToDeviceWidth(
                outer.maxWidth,
                hasPhysicalFold: device.hasPhysicalFold,
              );
            });

            return AnimatedBuilder(
              animation: Listenable.merge([motion, detail, store]),
              builder: (context, _) {
                return Column(
                  children: [
                    _Header(
                      foldProgress: motion.progress,
                      detailProgress: detail.value,
                      hasPhysicalFold: device.hasPhysicalFold,
                      onBack: detail.value > 0.01 ? closeAction : null,
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, bounds) => _Stage(
                          width: bounds.maxWidth,
                          height: bounds.maxHeight,
                          fold: motion.progress,
                          detail: detail.value,
                          hingeWidth: device.hingeWidth,
                          store: store,
                          onAction: openAction,
                          onBack: closeAction,
                        ),
                      ),
                    ),
                    FoldSimulatorBar(
                      progress: motion.progress,
                      autoDevice: motion.autoDevice,
                      onProgressChanged: motion.setProgress,
                      onAutoDeviceChanged: (value) {
                        motion.setAutoDevice(value);
                        if (value) {
                          motion.syncToDeviceWidth(
                            outer.maxWidth,
                            hasPhysicalFold: device.hasPhysicalFold,
                          );
                        }
                      },
                      onFold: motion.fold,
                      onUnfold: motion.unfold,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.foldProgress,
    required this.detailProgress,
    required this.hasPhysicalFold,
    required this.onBack,
  });

  final double foldProgress;
  final double detailProgress;
  final bool hasPhysicalFold;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final unfolded = foldProgress >= 0.5;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Material(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: !unfolded ? onBack : null,
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  !unfolded && detailProgress > 0.5
                      ? Icons.arrow_back_rounded
                      : Icons.screen_rotation_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FOLDABLE MOTION LAB',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  hasPhysicalFold
                      ? 'Physical fold detected'
                      : unfolded
                          ? 'Actions update the right pane'
                          : detailProgress > 0.5
                              ? 'Action opened full screen'
                              : 'Actions open full screen',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8C8B86),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: unfolded ? const Color(0xFFC8FF22) : Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              unfolded ? 'UNFOLDED' : 'FOLDED',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.width,
    required this.height,
    required this.fold,
    required this.detail,
    required this.hingeWidth,
    required this.store,
    required this.onAction,
    required this.onBack,
  });

  final double width;
  final double height;
  final double fold;
  final double detail;
  final double hingeWidth;
  final FoldLabStore store;
  final ValueChanged<LabActionType> onAction;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const horizontal = 20.0;
    const vertical = 10.0;
    final usable = math.max(0.0, width - horizontal * 2);
    final leftExpanded = math.min(390.0, math.max(280.0, usable * 0.38));
    final gap = hingeWidth > 0 ? math.max(hingeWidth + 12, 18.0) : 18.0;
    final rightExpanded = math.max(300.0, usable - leftExpanded - gap);

    final homeWidth = lerpDouble(usable, leftExpanded, fold)!;
    final compactDetailLeft = lerpDouble(usable + 42, 0, detail)!;
    final detailLeft = lerpDouble(compactDetailLeft, leftExpanded + gap, fold)!;
    final detailWidth = lerpDouble(usable, rightExpanded, fold)!;
    final compactRotation = lerpDouble(-165 * math.pi / 180, 0, detail)!;
    final rotation = lerpDouble(compactRotation, 0, fold)!;
    final opacity = lerpDouble(detail, 1, fold)!.clamp(0.0, 1.0).toDouble();
    final homeOpacity = (1 - (1 - fold) * detail * 0.82).clamp(0.0, 1.0).toDouble();
    final backOpacity = (detail * (1 - fold)).clamp(0.0, 1.0).toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(horizontal, vertical, horizontal, 10),
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: lerpDouble(-18 * detail, 0, fold)!,
              top: 0,
              bottom: 0,
              width: homeWidth,
              child: IgnorePointer(
                ignoring: fold < 0.5 && detail > 0.45,
                child: Opacity(
                  opacity: homeOpacity,
                  child: FoldHomePanel(
                    progress: fold,
                    selectedAction: store.selectedAction,
                    denseNavigation: store.denseNavigation,
                    onActionTap: onAction,
                  ),
                ),
              ),
            ),
            if (store.showFoldGuide)
              Positioned(
                left: math.max(0, leftExpanded + gap / 2 - 7),
                top: 12,
                bottom: 12,
                width: 14,
                child: Opacity(
                  opacity: fold,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.12 * fold),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: detailLeft,
              top: 0,
              width: detailWidth,
              height: math.max(0, height - vertical * 2),
              child: IgnorePointer(
                ignoring: opacity < 0.45,
                child: Opacity(
                  opacity: opacity,
                  child: Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0014)
                      ..rotateY(rotation),
                    child: FoldDetailPanel(
                      store: store,
                      compactBackOpacity: backOpacity,
                      onBack: onBack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
