import 'package:flutter/material.dart';
import 'package:genbi/components/glass.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  int _selected = 0;

  static const _navItems = [
    (label: 'Overview', icon: Icons.pie_chart_outline),
    (label: 'Transform', icon: Icons.auto_awesome_mosaic_outlined),
    (label: 'Dashboard', icon: Icons.dashboard_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GlassButton(label: 'New Analysis', icon: Icons.add, onTap: () {}),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.only(left: 12, bottom: 16),
              child: GlassLabel('SECTION I'),
            ),
            ..._navItems.mapIndexed(
              (i, item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _NavItem(
                  label: item.label,
                  icon: item.icon,
                  selected: _selected == i,
                  onTap: () => setState(() => _selected = i),
                ),
              ),
            ),
            const Spacer(),
            const GlassDivider(),
            const SizedBox(height: 16),
            const _AccountTile(),
          ],
        ),
      ),
    );
  }
}

// ─── Glass button (New Analysis) ─────────────────────────────────────────────
class _GlassButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GlassButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: _hovered
                  ? [AppColors.w(0.25), AppColors.w(0.15)]
                  : [AppColors.w(0.15), AppColors.w(0.05)],
            ),
            border: Border.all(color: AppColors.w(_hovered ? 0.3 : 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppColors.w(0.9), size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: AppColors.w(0.9),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Nav item ─────────────────────────────────────────────────────────────────
class _NavItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.selected
                ? AppColors.w(0.12)
                : _hovered
                ? AppColors.w(0.05)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: AppColors.w(widget.selected ? 1.0 : 0.5),
              ),
              const SizedBox(width: 16),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: widget.selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: AppColors.w(widget.selected ? 1.0 : 0.7),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Account tile ─────────────────────────────────────────────────────────────
class _AccountTile extends StatelessWidget {
  const _AccountTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: AppColors.w(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Pro Plan',
                  style: TextStyle(color: AppColors.w(0.4), fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: AppColors.w(0.4), size: 18),
        ],
      ),
    );
  }
}

// ─── Tiny extension for indexed map ──────────────────────────────────────────
extension _IndexedMap<T> on List<T> {
  Iterable<R> mapIndexed<R>(R Function(int i, T e) f) =>
      asMap().entries.map((e) => f(e.key, e.value));
}
