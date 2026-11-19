import 'package:flutter/material.dart';

/// Subtle entrance animation: fades in and slides up slightly.
/// Plays once when first inserted into the widget tree.
/// Rebuild-safe: pass a stable `key` (e.g. `ValueKey(item.id)`) to prevent
/// replay on parent rebuilds.
class EntranceFadeSlide extends StatelessWidget {
  final Widget child;
  final int index;
  final double slideDistance;

  const EntranceFadeSlide({
    super.key,
    required this.child,
    this.index = 0,
    this.slideDistance = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 40)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, slideDistance * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
