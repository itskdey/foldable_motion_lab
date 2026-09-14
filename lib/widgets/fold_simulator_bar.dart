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
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.14),
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
                  const Icon(
                    Icons.screen_rotation_alt_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Fold simulator',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFC8FF22),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white12,
                  trackHeight: 3,
                ),
                child: Slider(value: progress, onChanged: onProgressChanged),
              ),
              Row(
                children: [
                  if (compact) ...[
                    Expanded(child: _Button(label: 'Fold', icon: Icons.close_fullscreen_rounded, onTap: onFold)),
                    const SizedBox(width: 8),
                    Expanded(child: _Button(label: 'Unfold', icon: Icons.open_in_full_rounded, onTap: onUnfold)),
                  ] else ...[
                    _Button(label: 'Fold', icon: Icons.close_fullscreen_rounded, onTap: onFold),
                    const SizedBox(width: 8),
                    _Button(label: 'Unfold', icon: Icons.open_in_full_rounded, onTap: onUnfold),
                    const Spacer(),
                  ],
                  const SizedBox(width: 8),
                  Semantics(
                    button: true,
                    toggled: autoDevice,
                    label: 'Auto device',
                    child: Material(
                      color: autoDevice ? const Color(0xFFC8FF22) : Colors.white10,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => onAutoDeviceChanged(!autoDevice),
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: compact ? 44 : 110,
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sync_rounded, color: autoDevice ? Colors.black : Colors.white, size: 17),
                              if (!compact) ...[
                                const SizedBox(width: 6),
                                Text(
                                  'Auto device',
                                  style: TextStyle(
                                    color: autoDevice ? Colors.black : Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ],
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

class _Button extends StatelessWidget {
  const _Button({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 15),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
