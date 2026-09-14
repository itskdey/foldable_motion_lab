import 'package:flutter/material.dart';

class FoldSimulatorBar extends StatelessWidget {
  const FoldSimulatorBar({
    super.key,
    required this.progress,
    required this.autoDevice,
    required this.onProgressChanged,
    required this.onAutoDeviceChanged,
    required this.onFold,
    required this.onUnfold,
  });

  final double progress;
  final bool autoDevice;
  final ValueChanged<double> onProgressChanged;
  final ValueChanged<bool> onAutoDeviceChanged;
  final VoidCallback onFold;
  final VoidCallback onUnfold;

  @override
  Widget build(BuildContext context) {
    final folded = progress < 0.5;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1B19), Color(0xFF111210)],
        ),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: Colors.black.withValues(alpha: 0.18),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 540;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8FF22),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.screen_rotation_alt_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fold simulator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          autoDevice
                              ? 'Following device posture'
                              : 'Manual posture control',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.48),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFC8FF22),
                  inactiveTrackColor: Colors.white12,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white10,
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 7,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(value: progress, onChanged: onProgressChanged),
              ),
              Row(
                children: [
                  Expanded(
                    child: _PostureButton(
                      label: 'Folded',
                      icon: Icons.smartphone_rounded,
                      active: folded,
                      onTap: onFold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PostureButton(
                      label: compact ? 'Open' : 'Unfolded',
                      icon: Icons.view_sidebar_rounded,
                      active: !folded,
                      onTap: onUnfold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Semantics(
                    button: true,
                    toggled: autoDevice,
                    label: 'Auto device',
                    child: Tooltip(
                      message: autoDevice
                          ? 'Auto device enabled'
                          : 'Follow real device posture',
                      child: Material(
                        color: autoDevice
                            ? const Color(0xFFC8FF22)
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () => onAutoDeviceChanged(!autoDevice),
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: compact ? 46 : 104,
                            height: 44,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sync_rounded,
                                  color: autoDevice ? Colors.black : Colors.white,
                                  size: 17,
                                ),
                                if (!compact) ...[
                                  const SizedBox(width: 7),
                                  Text(
                                    'AUTO',
                                    style: TextStyle(
                                      color: autoDevice
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PostureButton extends StatelessWidget {
  const _PostureButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(
        color: active
            ? Colors.white.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: active
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? const Color(0xFFC8FF22) : Colors.white60,
                  size: 16,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
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
