import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool expand;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.expand = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 51, 27, 235), Color(0xFF6A11CB)],
              stops: [0.2, 0.8],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF6A11CB,
                ).withValues(alpha: _pressed ? 0.18 : 0.35),
                blurRadius: _pressed ? 12 : 20,
                offset: Offset(0, _pressed ? 4 : 10),
              ),
            ],
          ),
          child: Material(
            // Let the gradient show through; only used for ink ripple.
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.white.withValues(alpha: 0.15),
              highlightColor: Colors.white.withValues(alpha: 0.05),
              onTap: () {
                widget.onTap!();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: widget.expand
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
