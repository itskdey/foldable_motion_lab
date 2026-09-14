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
    final heroHeight = lerpDouble(252, 212, progress)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FoldHero(progress: progress, height: heroHeight),
          SizedBox(height: lerpDouble(20, 16, progress)!),
          _ActionSection(
            compact: compact,
            dense: denseNavigation,
            selectedAction: selectedAction,
            onActionTap: onActionTap,
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
    final titleSize = lerpDouble(36, 29, progress)!;
    final limeSize = lerpDouble(102, 78, progress)!;
    final unfolded = progress >= 0.5;

    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(lerpDouble(24, 20, progress)!),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF171816), Color(0xFF0E0F0D)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -56,
            top: -72,
            child: Container(
              width: 224,
              height: 224,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 30,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 18,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 10,
            child: Transform.rotate(
              angle: lerpDouble(-0.16, -0.06, progress)!,
              child: Container(
                width: limeSize,
                height: limeSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8FF22),
                  borderRadius: BorderRadius.circular(27),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8FF22).withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  unfolded
                      ? Icons.view_sidebar_rounded
                      : Icons.smartphone_rounded,
                  size: lerpDouble(40, 32, progress)!,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: const Text(
                      'POSTURE AWARE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _LiveDot(label: unfolded ? 'DUAL PANE' : 'COMPACT'),
                ],
              ),
              const Spacer(),
              Text(
                'One flow.\nTwo forms.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  height: 0.92,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.6,
                ),
              ),
              const SizedBox(height: 11),
              SizedBox(
                width: 210,
                child: Text(
                  unfolded
                      ? 'Keep navigation visible while the active workspace moves beside it.'
                      : 'Open an action full screen, then unfold without losing context.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFC8FF22),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.compact,
    required this.dense,
    required this.selectedAction,
    required this.onActionTap,
  });

  final bool compact;
  final bool dense;
  final LabActionType selectedAction;
  final ValueChanged<LabActionType> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dense ? 7 : 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              dense ? 8 : 10,
              dense ? 7 : 9,
              dense ? 8 : 10,
              dense ? 5 : 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        compact ? 'Quick actions' : 'Workspace',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        compact
                            ? 'Tap to open full screen'
                            : 'Tap to update the detail pane',
                        style: const TextStyle(
                          color: Color(0xFF8C8B86),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EFE8),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${labActions.length} TOOLS',
                    style: const TextStyle(
                      color: Color(0xFF696862),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...labActions.map(
            (action) => _ActionTile(
              action: action,
              selected: action.type == selectedAction,
              dense: dense,
              onTap: () => onActionTap(action.type),
            ),
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
      margin: EdgeInsets.only(bottom: dense ? 3 : 5),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF151614) : Colors.transparent,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
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
                        ? const Color(0xFFC8FF22)
                        : const Color(0xFFF0EEE7),
                    borderRadius: BorderRadius.circular(dense ? 13 : 15),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    action.icon,
                    size: dense ? 20 : 22,
                    color: Colors.black,
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
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Text(
                            action.accentLabel,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFFC8FF22)
                                  : const Color(0xFF85847D),
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
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
                                ? Colors.white.withValues(alpha: 0.52)
                                : const Color(0xFF99978F),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.10)
                        : const Color(0xFFF5F3ED),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: selected ? Colors.white : const Color(0xFF7D7B74),
                  ),
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
        color: const Color(0xFFE7E4DA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
      ),
      child: Row(
        children: [
          _MiniPosture(compact: compact),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        compact ? 'Folded behavior' : 'Unfolded behavior',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const Icon(Icons.auto_awesome_rounded, size: 16),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  compact
                      ? 'Actions take over the whole screen. Unfold and the same state settles into the right pane.'
                      : 'Navigation stays anchored on the left while the selected workspace updates on the right.',
                  style: const TextStyle(
                    color: Color(0xFF74726B),
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

class _MiniPosture extends StatelessWidget {
  const _MiniPosture({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 54,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF161715),
        borderRadius: BorderRadius.circular(17),
      ),
      child: compact
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xFFC8FF22),
                borderRadius: BorderRadius.circular(9),
              ),
            )
          : Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8FF22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
