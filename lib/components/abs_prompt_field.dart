import 'package:flutter/material.dart';

import 'glass.dart';

class AbsPromptField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onSubmit;

  const AbsPromptField({
    super.key,
    required this.controller,
    this.hint = 'Ask anything about your data…',
    this.onSubmit,
  });

  @override
  State<AbsPromptField> createState() => _AbsPromptFieldState();
}

class _AbsPromptFieldState extends State<AbsPromptField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.w(0.13), AppColors.w(0.05)],
        ),
        border: Border.all(
          color: AppColors.w(_focused ? 0.35 : 0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (v) => setState(() => _focused = v),
                child: TextField(
                  controller: widget.controller,
                  style: TextStyle(
                    color: AppColors.w(0.9),
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: AppColors.w(0.3), fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => widget.onSubmit?.call(),
                ),
              ),
            ),
            _SendButton(onTap: widget.onSubmit ?? () {}),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SendButton({required this.onTap});

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
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
          margin: const EdgeInsets.all(8),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.w(_hovered ? 0.18 : 0.08),
          ),
          child: Icon(
            Icons.arrow_upward_rounded,
            color: AppColors.w(0.8),
            size: 18,
          ),
        ),
      ),
    );
  }
}
