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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FoldHero(progress: progress),
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
  const _FoldHero({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final height = lerpDouble(254, 230, progress)!;

    return Container(
      width: double.infinity,
      height: height,
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
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 290;
          final padding = narrow ? 18.0 : 22.0;
          final titleSize = narrow
              ? lerpDouble(30, 27, progress)!
              : lerpDouble(36, 30, progress)!;
          final limeSize = narrow ? 68.0 : lerpDouble(98, 76, progress)!;
          final unfolded = progress >= 0.5;

          return Stack(
            children: [
              Positioned(
                right: -58,
                top: -76,
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
                right: narrow ? 12 : 10,
                bottom: narrow ? 14 : 10,
                child: Transform.rotate(
                  angle: lerpDouble(-0.16, -0.06, progress)!,
                  child: Container(
                    width: limeSize,
                    height: limeSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8FF22),
                      borderRadius: BorderRadius.circular(narrow ? 21 : 27),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC8FF22).withValues(alpha: 0.18),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      unfolded
                          ? Icons.view_sidebar_rounded
                          : Icons.smartphone_rounded,
                      size: narrow ? 29 : lerpDouble(39, 32, progress)!,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: narrow ? 9 : 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              narrow ? 'POSTURE' : 'POSTURE AWARE',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFC8FF22),
                          ),
                        ),
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
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: narrow
                          ? constraints.maxWidth - padding * 2 - 72
                          : constraints.maxWidth * 0.62,
                      child: Text(
                        unfolded
                            ? 'Navigation stays visible while the live workspace moves beside it.'
                            : 'Open full screen, then unfold without losing context.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: narrow ? 9 : 10,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
        color: Colors.white.withValues(alpha: 0.94),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF8C8B86),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EFE8),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${labActions.length}',
                    style: const TextStyle(
                      color: Color(0xFF696862),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
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
              horizontal: dense ? 9 : 11,
              vertical: dense ? 9 : 11,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: dense ? 38 : 43,
                  height: dense ? 38 : 43,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFC8FF22)
                        : const Color(0xFFF0EEE7),
                    borderRadius: BorderRadius.circular(dense ? 12 : 14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    action.icon,
                    size: dense ? 19 : 21,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: dense ? 9 : 11),
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
                                fontSize: dense ? 12 : 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            action.accentLabel,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFFC8FF22)
                                  : const Color(0xFF85847D),
                              fontSize: 7,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      if (!dense) ...[
                        const SizedBox(height: 3),
                        Text(
                          action.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected
                                ? Colors.white.withValues(alpha: 0.50)
                                : const Color(0xFF99978F),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.10)
                        : const Color(0xFFF5F3ED),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E4DA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
      ),
      child: Row(
        children: [
          _MiniPosture(compact: compact),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact ? 'Folded behavior' : 'Unfolded behavior',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  compact
                      ? 'Actions fill the screen. Unfold and the same state moves right.'
                      : 'Navigation stays left while the active workspace updates right.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF74726B),
                    fontSize: 10,
                    height: 1.4,
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
      width: 58,
      height: 50,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF161715),
        borderRadius: BorderRadius.circular(16),
      ),
      child: compact
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xFFC8FF22),
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8FF22),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
