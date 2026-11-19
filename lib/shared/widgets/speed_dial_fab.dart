import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Data for a single action button in the speed dial.
class SpeedDialAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SpeedDialAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// A floating action button centered at the bottom that expands into floating
/// labelled nodes in an arc above it. Renders a full-screen backdrop when open.
/// Designed for Scaffold.floatingActionButton so Scaffold can keep the FAB at
/// FloatingActionButtonLocation.centerDocked.
class SpeedDialFAB extends StatefulWidget {
  final List<SpeedDialAction> actions;

  const SpeedDialFAB({super.key, required this.actions});

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  static const double _nodeWidth = 124;
  static const double _nodeHeight = 104;

  bool _open = false;
  final GlobalKey _fabKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _controller.addListener(() => _overlayEntry?.markNeedsBuild());
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openDial();
    }
  }

  void _openDial() {
    final overlay = Overlay.of(context, rootOverlay: true);
    setState(() => _open = true);
    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    overlay.insert(_overlayEntry!);
    _controller.forward(from: 0);
  }

  void _close({bool immediate = false}) {
    if (!_open) return;

    setState(() => _open = false);
    if (immediate) {
      _controller.value = 0;
      _removeOverlay();
      return;
    }

    _controller.reverse().whenComplete(_removeOverlay);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Offset _fabCenter(BuildContext overlayContext) {
    final renderObject = _fabKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.localToGlobal(renderObject.size.center(Offset.zero));
    }

    final size = MediaQuery.sizeOf(overlayContext);
    return Offset(size.width / 2, size.height - kBottomNavigationBarHeight);
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final fabCenter = _fabCenter(overlayContext);
    final offsets = [
      const Offset(0, -160),
      const Offset(-140, -90),
      const Offset(140, -90),
    ];

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
          ...List.generate(widget.actions.length, (i) {
            final action = widget.actions[i];
            final offset = offsets[i];

            return AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                final t = _expandAnimation.value;
                // Stagger: each node starts 6 % into the animation after
                // the previous one, so they fan out sequentially.
                final sd = i * 0.06;
                final st = ((t - sd) / (1.0 - sd)).clamp(0.0, 1.0);
                return Positioned(
                  left: fabCenter.dx - (_nodeWidth / 2) + (offset.dx * st),
                  top: fabCenter.dy - (_nodeHeight / 2) + (offset.dy * st),
                  width: _nodeWidth,
                  height: _nodeHeight,
                  child: Opacity(
                    opacity: st.clamp(0.0, 1.0),
                    child: Transform.scale(scale: st, child: child),
                  ),
                );
              },
              child: _ActionNode(
                icon: action.icon,
                label: action.label,
                onTap: () {
                  _close(immediate: true);
                  action.onTap();
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: _fabKey,
      onPressed: _toggle,
      elevation: _open ? 8 : 4,
      child: AnimatedRotation(
        turns: _open ? 0.125 : 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            _open ? Icons.close_rounded : Icons.add_rounded,
            key: ValueKey(_open),
            size: 28,
          ),
        ),
      ),
    );
  }
}

/// A single floating node: a circle with icon and an attached text label.
class _ActionNode extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionNode({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label above the button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Connecting line
          Container(
            width: 1,
            height: 10,
            color: AppColors.textMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 2),
          // Circle button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
