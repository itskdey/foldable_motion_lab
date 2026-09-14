import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../fold/fold_device_info.dart';
import '../fold/fold_motion_controller.dart';
import '../widgets/fold_demo_content.dart';
import '../widgets/fold_simulator_bar.dart';

class FoldableLabScreen extends StatefulWidget {
  const FoldableLabScreen({super.key});

  @override
  State<FoldableLabScreen> createState() => _FoldableLabScreenState();
}

class _FoldableLabScreenState extends State<FoldableLabScreen>
    with SingleTickerProviderStateMixin {
  late final FoldMotionController _motion;

  int selectedIndex = 0;

  final items = const [
    FoldDemoItem(
      title: 'Reader',
      subtitle: 'Single-pane document view',
      icon: Icons.chrome_reader_mode_outlined,
    ),
    FoldDemoItem(
      title: 'Workspace',
      subtitle: 'Master-detail two-pane mode',
      icon: Icons.view_sidebar_outlined,
    ),
    FoldDemoItem(
      title: 'Preview',
      subtitle: 'Inspect the fold transition',
      icon: Icons.auto_awesome_motion_outlined,
    ),
    FoldDemoItem(
      title: 'Settings',
      subtitle: 'Tune your fold experience',
      icon: Icons.tune_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _motion = FoldMotionController(
      vsync: this,
      expandedBreakpoint: 600,
    );
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final device = FoldDeviceInfo.fromMediaQuery(mediaQuery);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, outerConstraints) {
            _motion.initializeForWidth(outerConstraints.maxWidth);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _motion.syncToDeviceWidth(outerConstraints.maxWidth);
            });

            return AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                return Column(
                  children: [
                    _Header(
                      progress: _motion.progress,
                      hasPhysicalFold: device.hasPhysicalFold,
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _FoldStage(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            progress: _motion.progress,
                            hingeWidth: device.hingeWidth,
                            items: items,
                            selectedIndex: selectedIndex,
                            onSelected: (index) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    FoldSimulatorBar(
                      progress: _motion.progress,
                      autoDevice: _motion.autoDevice,
                      onProgressChanged: _motion.setProgress,
                      onAutoDeviceChanged: (enabled) {
                        _motion.setAutoDevice(enabled);

                        if (enabled) {
                          _motion.syncToDeviceWidth(
                            outerConstraints.maxWidth,
                          );
                        }
                      },
                      onFold: () {
                        _motion.fold();
                      },
                      onUnfold: () {
                        _motion.unfold();
                      },
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
    required this.progress,
    required this.hasPhysicalFold,
  });

  final double progress;
  final bool hasPhysicalFold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: lerpDouble(-0.08, 0.08, progress)!,
              child: const Icon(
                Icons.screen_rotation_alt_outlined,
                color: Colors.white,
                size: 24,
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
                const SizedBox(height: 2),
                Text(
                  hasPhysicalFold
                      ? 'Physical fold detected'
                      : 'Smooth fold / unfold playground',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Text(
              progress < 0.5 ? 'FOLDED' : 'UNFOLDED',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoldStage extends StatelessWidget {
  const _FoldStage({
    required this.width,
    required this.height,
    required this.progress,
    required this.hingeWidth,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final double width;
  final double height;
  final double progress;
  final double hingeWidth;
  final List<FoldDemoItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 20.0;
    const verticalPadding = 10.0;

    final availableWidth =
        math.max(0.0, width - horizontalPadding * 2);

    final expandedLeftWidth = math.min(
      390.0,
      math.max(
        280.0,
        availableWidth * 0.39,
      ),
    );

    final expandedGap = hingeWidth > 0
        ? math.max(hingeWidth + 12, 18.0)
        : 18.0;

    final leftWidth = lerpDouble(
      availableWidth,
      expandedLeftWidth,
      progress,
    )!;

    final rightWidth = math.max(
      300.0,
      availableWidth - expandedLeftWidth - expandedGap,
    );

    final rightLeft = lerpDouble(
      availableWidth + 40,
      expandedLeftWidth + expandedGap,
      progress,
    )!;

    final rightRotation = lerpDouble(
      -165 * math.pi / 180,
      0,
      progress,
    )!;

    final rightOpacity = Curves.easeOutCubic.transform(
      ((progress - 0.05) / 0.95).clamp(0.0, 1.0),
    );

    final leftScale = lerpDouble(
      1,
      0.995,
      progress,
    )!;

    final foldShadowOpacity =
        Curves.easeInOut.transform(progress) * 0.14;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        10,
      ),
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: leftWidth,
              child: Transform.scale(
                scale: leftScale,
                alignment: Alignment.centerLeft,
                child: FoldLeftPane(
                  progress: progress,
                  items: items,
                  selectedIndex: selectedIndex,
                  onSelected: onSelected,
                ),
              ),
            ),

            // Animated crease / hinge shadow.
            Positioned(
              left: math.max(
                0,
                expandedLeftWidth +
                    expandedGap / 2 -
                    6,
              ),
              top: 12,
              bottom: 12,
              width: 12,
              child: IgnorePointer(
                child: Opacity(
                  opacity: progress,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(
                            alpha: foldShadowOpacity,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: rightLeft,
              top: 0,
              width: rightWidth,
              height: math.max(
                0,
                height - verticalPadding * 2,
              ),
              child: IgnorePointer(
                ignoring: progress < 0.60,
                child: Opacity(
                  opacity: rightOpacity,
                  child: Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0014)
                      ..rotateY(rightRotation),
                    child: FoldRightPane(
                      item: items[selectedIndex],
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
