import 'dart:ui';
import 'package:flutter/material.dart';

class AbsPromptField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSend;
  final VoidCallback? onAttach;

  const AbsPromptField({
    super.key,
    required this.controller,
    this.hintText = 'Message GenInSight...',
    this.onSend,
    this.onAttach,
  });

  @override
  State<AbsPromptField> createState() => _AbsPromptFieldState();
}

class _AbsPromptFieldState extends State<AbsPromptField> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _hasText = false;

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });

    // Listen to text changes to toggle the send button state
    widget.controller.addListener(() {
      final hasText = widget.controller.text.trim().isNotEmpty;
      if (_hasText != hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine visual intensity based on state
    final isActive = _isHovered || _isFocused;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: isActive ? 0.16 : 0.12),
              Colors.white.withValues(alpha: isActive ? 0.08 : 0.04),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: isActive ? 0.30 : 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ─── Left Action Button (Attachment) ───────────────────────
                  _ActionButton(
                    icon: Icons.add,
                    onTap: widget.onAttach,
                    tooltip: 'Attach file',
                  ),

                  const SizedBox(width: 8),

                  // ─── Text Input Area ───────────────────────────────────────
                  Expanded(
                    child: Padding(
                      // Adds a slight padding to center text vertically when single-lined
                      padding: const EdgeInsets.only(bottom: 6, top: 4),
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 5, // Expands up to 5 lines before scrolling
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 14.5,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true, // Removes default internal padding
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ─── Right Action Button (Dynamic Send/Mic) ────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                    child: _hasText
                        ? _PrimarySendButton(
                            key: const ValueKey('sendBtn'),
                            onTap: widget.onSend,
                          )
                        : _ActionButton(
                            key: const ValueKey('micBtn'),
                            icon: Icons.mic_none_outlined,
                            onTap: () {
                              // Optional: Handle Voice Input
                            },
                            tooltip: 'Voice input',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  const _ActionButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip = '',
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: Colors.white.withValues(alpha: _hovered ? 0.9 : 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimarySendButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _PrimarySendButton({super.key, this.onTap});

  @override
  State<_PrimarySendButton> createState() => _PrimarySendButtonState();
}

class _PrimarySendButtonState extends State<_PrimarySendButton> {
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered
                ? Colors.white
                : Colors.white.withValues(alpha: 0.9),
            boxShadow: [
              if (_hovered)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_upward_rounded, // Modern LLM upward arrow
              size: 20,
              color: Color(0xFF0D1B2A), // Matches your deep midnight blue theme
            ),
          ),
        ),
      ),
    );
  }
}
