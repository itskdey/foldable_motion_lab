import 'dart:ui';

import 'package:flutter/material.dart';

class FoldDemoItem {
  const FoldDemoItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class FoldLeftPane extends StatelessWidget {
  const FoldLeftPane({
    super.key,
    required this.progress,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final double progress;
  final List<FoldDemoItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final heroHeight = lerpDouble(244, 220, progress)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _HeroCard(
            progress: progress,
            height: heroHeight,
          ),
          SizedBox(height: lerpDouble(24, 18, progress)!),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: List.generate(
                items.length,
                (index) => _NavigationTile(
                  item: items[index],
                  selected: selectedIndex == index,
                  progress: progress,
                  onTap: () => onSelected(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoldRightPane extends StatelessWidget {
  const FoldRightPane({
    super.key,
    required this.item,
  });

  final FoldDemoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 350;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TweenAnimationBuilder<double>(
                    key: ValueKey(item.title),
                    tween: Tween(begin: 0.78, end: 1),
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0EC),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        item.icon,
                        size: 28,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1ED),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: narrow ? 31 : 42,
                  height: 0.95,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.7,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: const Color(0xFF74746E),
                  fontSize: narrow ? 14 : 17,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              _RightActions(narrow: narrow),
            ],
          );
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.progress,
    required this.height,
  });

  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final titleSize = lerpDouble(34, 28, progress)!;
    final limeSize = lerpDouble(100, 82, progress)!;

    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(lerpDouble(24, 20, progress)!),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(
          lerpDouble(32, 28, progress)!,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -55,
            top: -70,
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
            bottom: 10,
            child: Transform.rotate(
              angle: lerpDouble(-0.18, -0.10, progress)!,
              child: Container(
                width: limeSize,
                height: limeSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8FF22),
                  borderRadius: BorderRadius.circular(27),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.document_scanner_outlined,
                  size: lerpDouble(40, 34, progress)!,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'FOLD LAB',
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
                'One layout.\nTwo forms.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  height: 0.95,
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

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.item,
    required this.selected,
    required this.progress,
    required this.onTap,
  });

  final FoldDemoItem item;
  final bool selected;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 4),
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
              horizontal: lerpDouble(14, 11, progress)!,
              vertical: 13,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.12)
                        : const Color(0xFFF0F0EC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 280),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
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
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 19,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF999993),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RightActions extends StatelessWidget {
  const _RightActions({
    required this.narrow,
  });

  final bool narrow;

  @override
  Widget build(BuildContext context) {
    if (narrow) {
      return Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: _OpenButton(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: _ArrowButton(),
          ),
        ],
      );
    }

    return const Row(
      children: [
        Expanded(
          child: _OpenButton(),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 54,
          height: 54,
          child: _ArrowButton(),
        ),
      ],
    );
  }
}

class _OpenButton extends StatelessWidget {
  const _OpenButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Text(
          'Open workspace',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF0F0EC),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(17),
        child: const Center(
          child: Icon(
            Icons.arrow_outward_rounded,
            size: 23,
          ),
        ),
      ),
    );
  }
}
