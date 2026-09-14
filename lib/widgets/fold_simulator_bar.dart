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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
          final compact = constraints.maxWidth < 560;

          final controls = [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFC8FF22),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white12,
                ),
                child: Slider(
                  value: progress,
                  onChanged: onProgressChanged,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SmallButton(
              label: 'Fold',
              onTap: onFold,
            ),
            const SizedBox(width: 8),
            _SmallButton(
              label: 'Unfold',
              onTap: onUnfold,
            ),
          ];

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
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Auto device',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Switch.adaptive(
                    value: autoDevice,
                    onChanged: onAutoDeviceChanged,
                  ),
                ],
              ),
              if (compact) ...[
                Row(children: controls),
              ] else
                Row(children: controls),
            ],
          );
        },
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
