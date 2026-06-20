import 'dart:ui';
import 'package:flutter/material.dart';

// ─── Palette ──────────────────────────────────────────────────────────────────
abstract class AppColors {
  static const bg = [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF415A77)];

  static Color w(double a) => Colors.white.withValues(alpha: a);
}

// ─── GlassBox ─────────────────────────────────────────────────────────────────
// Every glass surface in the app is this one widget.
class GlassBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double borderOpacity;

  const GlassBox({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding,
    this.borderOpacity = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.w(0.13), AppColors.w(0.05)],
        ),
        border: Border.all(color: AppColors.w(borderOpacity), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 64,
            offset: const Offset(0, 32),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: child,
        ),
      ),
    );
  }
}

// ─── AppScaffold ──────────────────────────────────────────────────────────────
// Full-screen gradient + ambient orbs. Wrap every page with this.
class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.bg,
          ),
        ),
        child: Stack(
          children: [
            _Orb(320, const Color(0xFF7850FF), 0.35, top: -80, right: -60),
            _Orb(260, const Color(0xFF00B4FF), 0.22, bottom: -60, left: -40),
            child,
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final double? top, bottom, left, right;

  const _Orb(
    this.size,
    this.color,
    this.opacity, {
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

// ─── GlassDivider ─────────────────────────────────────────────────────────────
class GlassDivider extends StatelessWidget {
  final bool vertical;
  const GlassDivider({super.key, this.vertical = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? 1 : double.infinity,
      height: vertical ? double.infinity : 1,
      color: AppColors.w(0.08),
    );
  }
}

// ─── GlassLabel (section header text) ────────────────────────────────────────
class GlassLabel extends StatelessWidget {
  final String text;
  const GlassLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: AppColors.w(0.35),
      ),
    );
  }
}
