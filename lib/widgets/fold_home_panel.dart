import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/lab_action.dart';

class FoldHomePanel extends StatelessWidget {
  const FoldHomePanel({
    super.key,
    required this.progress,
    required this.selectedAction,
    required this.denseNavigation,
    required this.onActionTap,
  });

  final double progress;
  final LabActionType selectedAction;
  final bool denseNavigation;
  final ValueChanged<LabActionType> onActionTap;

  @override
  Widget build(BuildContext context) {
    final compact = progress < 0.5;
    final heroHeight = lerpDouble(232, 196, progress)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FoldHero(progress: progress, height: heroHeight),
          SizedBox(height: lerpDouble(22, 16, progress)!),
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(denseNavigation ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    denseNavigation ? 8 : 10,
                    denseNavigation ? 8 : 10,
                    denseNavigation ? 8 : 10,
                    denseNavigation ? 4 : 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          compact ? 'Actions' : 'Workspace',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      Text(
                        compact ? 'opens full screen' : 'updates right pane',
                        style: const TextStyle(
                          color: Color(0xFF8C8B86),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ...labActions.map(
                  (action) => _ActionTile(
                    action: action,
                    selected: action.type == selectedAction,
                    dense: denseNavigation,
                    onTap: () => onActionTap(action.type),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _BehaviorCard(progress: progress),
        ],
      ),
    );
  }
}

class _FoldHero extends StatelessWidget {
  const _FoldHero({required this.progress, required this.height});

  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final titleSize = lerpDouble(34, 28, progress)!;
    final limeSize = lerpDouble(96, 76, progress)!;

    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(lerpDouble(24, 20, progress)!),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -52,
            top: -72,
            child: Container(
              width: 215,
              height: 215,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 30,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Transform.rotate(
              angle: lerpDouble(-0.16, -0.07, progress)!,
              child: Container(
                width: limeSize,
                height: limeSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8FF22),
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.screen_rotation_alt_outlined,
                  size: lerpDouble(38, 31, progress)!,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'FOLD FIRST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Same action.\nDifferent posture.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  height: 0.94,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.selected,
    required this.dense,
    required this.onTap,
  });

  final LabActionDefinition action;
  final bool selected;
  final bool dense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.only(bottom: dense ? 2 : 4),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dense ? 10 : 13,
              vertical: dense ? 9 : 12,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: dense ? 40 : 46,
                  height: dense ? 40 : 46,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.12)
                        : const Color(0xFFF0F0EC),
                    borderRadius: BorderRadius.circular(dense ? 13 : 15),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    action.icon,
                    size: dense ? 20 : 22,
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(width: dense ? 10 : 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              action.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontSize: dense ? 13 : 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : const Color(0xFFF2F2EE),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              action.accentLabel,
                              style: TextStyle(
                                color: selected ? Colors.white70 : const Color(0xFF777772),
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!dense) ...[
                        const SizedBox(height: 4),
                        Text(
                          action.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected
                                ? Colors.white.withValues(alpha: 0.55)
                                : const Color(0xFF999993),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: selected ? Colors.white : const Color(0xFF999993),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BehaviorCard extends StatelessWidget {
  const _BehaviorCard({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    final compact = progress < 0.5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E7DF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Icon(
              compact ? Icons.open_in_full_rounded : Icons.view_sidebar_outlined,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? 'Folded behavior' : 'Unfolded behavior',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  compact
                      ? 'Tap an action and it opens as a full-screen workspace. Unfold it and the same workspace moves into the right pane.'
                      : 'Tap an action on the left and only the right pane changes. Fold again and the selected action can become the full-screen workspace.',
                  style: const TextStyle(
                    color: Color(0xFF74746E),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
