import 'dart:ui';

import 'package:flutter/widgets.dart';

class FoldDeviceInfo {
  const FoldDeviceInfo({
    required this.windowSize,
    required this.verticalFold,
  });

  final Size windowSize;
  final Rect? verticalFold;

  bool get hasPhysicalFold => verticalFold != null;

  double get hingeWidth => verticalFold?.width ?? 0;

  static FoldDeviceInfo fromMediaQuery(MediaQueryData mediaQuery) {
    return FoldDeviceInfo(
      windowSize: mediaQuery.size,
      verticalFold: _findVerticalFold(
        mediaQuery.displayFeatures,
        mediaQuery.size,
      ),
    );
  }

  static Rect? _findVerticalFold(
    List<DisplayFeature> features,
    Size screenSize,
  ) {
    for (final feature in features) {
      final isFold =
          feature.type == DisplayFeatureType.fold ||
          feature.type == DisplayFeatureType.hinge;

      // Ignore punch-hole cameras and display cutouts.
      if (!isFold) {
        continue;
      }

      final bounds = feature.bounds;
      final isVertical = bounds.height > bounds.width;
      final spansUsefulHeight =
          bounds.height >= screenSize.height * 0.45;

      if (isVertical && spansUsefulHeight) {
        return bounds;
      }
    }

    return null;
  }
}
